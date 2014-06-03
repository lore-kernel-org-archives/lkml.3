Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262AbaFCUio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:38:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:60852 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046AbaFCUi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:38:29 -0400
Date: Tue, 3 Jun 2014 17:38:23 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf/probe: Fix perf probe to find
 correct variable DIE
Message-ID: <20140603203823.GG3696@kernel.org>
References: <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <20140529121930.30879.87092.stgit@ltc230.yrl.intra.hitachi.co.jp>
 <53872A72.6040007@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53872A72.6040007@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 29, 2014 at 09:39:14PM +0900, Masami Hiramatsu escreveu:
> Hi Arnaldo,
> 
> Here is the patch which fixes perf probe to find variable
> location correctly, on the recent dwarf format. This is not
> related to the SEGV issue which I fixed in previous mail.

Hey, if I apply just this one I got my problem solved, i.e. no more
segfaults and also I managed to add that problem, the variable is there,
all works, why do I need the first one?

Without your two patches:

[root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
Added new event:
Segmentation fault (core dumped)
[root@zoo ~]#

With this ([BUGFIX] perf/probe: Fix perf probe to find correct variable DIE):

Trying to reference a bogus variable, one that is not available at this
function:

Removed event: probe:vfs_getname
[root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=BOGUS->name:string'
Failed to find 'BOGUS' in this function.
  Error: Failed to add events. (-2)
[root@zoo ~]#

Perfect!

Now trying to reference a bogus member name:

[root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->BOGUS:string'
result(type:filename) has no member BOGUS.
Failed to find 'result' in this function.
  Error: Failed to add events. (-22)
[root@zoo ~]#

No segfault, albeit it produces a bogus error message, as it clearly
_finds_ the 'result' variable, its just that it is of a struct type that
_has_ no such 'BOGUS' _member_.

Also I suggest removing that last "Error:" line, what is its value for
users or developers?

Now if I do it all correctly:

[root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
Added new event:
  probe:vfs_getname    (on getname_flags:65 with pathname=result->name:string)

You can now use it in all perf tools, such as:

	perf record -e probe:vfs_getname -aR sleep 1

[root@zoo ~]#

Ok, it works again!

And if I try to use it:

[root@zoo ~]# perf record -e probe:vfs_getname -a sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.562 MB perf.data (~24570 samples) ]
[root@zoo ~]# perf script | head -5
            perf   716 [000] 17842.271777: probe:vfs_getname: (ffffffff811c2e43) pathname="/home/acme/libexec/perf-core/sleep"
            perf   716 [000] 17842.271794: probe:vfs_getname: (ffffffff811c2e43) pathname="/usr/lib64/ccache/sleep"
            perf   716 [000] 17842.271800: probe:vfs_getname: (ffffffff811c2e43) pathname="/usr/local/sbin/sleep"
            perf   716 [000] 17842.271804: probe:vfs_getname: (ffffffff811c2e43) pathname="/usr/local/bin/sleep"
            perf   716 [000] 17842.271808: probe:vfs_getname: (ffffffff811c2e43) pathname="/sbin/sleep"
[root@zoo ~]#

Works as expected.

So no segfault anywhere, while if I apply just that one that fixes the segfault I get:

[root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
Failed to find the location of result at this address.
 Perhaps, it has been optimized out.
Failed to find 'result' in this function.
  Error: Failed to add events. (-22)
[root@zoo ~]#

It doesn't work, which is a regression, as applying just the first one allows
us to retrieve that variable.

[root@zoo ~]# perf probe -V getname_flags:65
Available variables at getname_flags:65
        @<getname_flags+227>
                char*   filename
                int     len
                int*    empty
                long int        max
                struct filename*        result
[root@zoo ~]#

I.e. applying just the one that fixes just the segfault:

  perf probe: Fix a segfault if asked for variable it doesn't find

"Fixes" the segfault but introduces a regression.

Can we apply just this one:

 perf probe: Fix to find correct variable DIE

Because even when we specify a "variable that it doesn't find", it works well.

Regards,

- Arnaldo
 
> Thank you,
> 
> (2014/05/29 21:19), Masami Hiramatsu wrote:
> > Fix perf probe to find correct variable DIE which has location or
> > external instance by tracking down the lexical blocks.
> > 
> > Current die_find_variable() expects that the all variable DIEs
> > which has DW_TAG_variable have a location. However, since recent
> > dwarf information may have declaration variable DIEs at the
> > entry of function (subprogram), die_find_variable() returns it.
> > 
> > To solve this problem, it must track down the DIE tree to find
> > a DIE which has an actual location or a reference for external
> > instance.
> > 
> > e.g. finding a DIE which origin is <0xdc73>;
> > 
> >  <1><11496>: Abbrev Number: 95 (DW_TAG_subprogram)
> >     <11497>   DW_AT_abstract_origin: <0xdc42>
> >     <1149b>   DW_AT_low_pc      : 0x1850
> > [...]
> >  <2><114cc>: Abbrev Number: 119 (DW_TAG_variable) <- this is a declaration
> >     <114cd>   DW_AT_abstract_origin: <0xdc73>
> >  <2><114d1>: Abbrev Number: 119 (DW_TAG_variable)
> > [...]
> >  <3><115a7>: Abbrev Number: 105 (DW_TAG_lexical_block)
> >     <115a8>   DW_AT_ranges      : 0xaa0
> >  <4><115ac>: Abbrev Number: 96 (DW_TAG_variable) <- this has a location
> >     <115ad>   DW_AT_abstract_origin: <0xdc73>
> >     <115b1>   DW_AT_location    : 0x486c        (location list)
> > 
> > Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  tools/perf/util/dwarf-aux.c |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
> > index 7defd77..cc66c40 100644
> > --- a/tools/perf/util/dwarf-aux.c
> > +++ b/tools/perf/util/dwarf-aux.c
> > @@ -747,14 +747,17 @@ struct __find_variable_param {
> >  static int __die_find_variable_cb(Dwarf_Die *die_mem, void *data)
> >  {
> >  	struct __find_variable_param *fvp = data;
> > +	Dwarf_Attribute attr;
> >  	int tag;
> >  
> >  	tag = dwarf_tag(die_mem);
> >  	if ((tag == DW_TAG_formal_parameter ||
> >  	     tag == DW_TAG_variable) &&
> > -	    die_compare_name(die_mem, fvp->name))
> > +	    die_compare_name(die_mem, fvp->name) &&
> > +	/* Does the DIE have location information or external instance? */
> > +	    (dwarf_attr(die_mem, DW_AT_external, &attr) ||
> > +	     dwarf_attr(die_mem, DW_AT_location, &attr)))
> >  		return DIE_FIND_CB_END;
> > -
> >  	if (dwarf_haspc(die_mem, fvp->addr))
> >  		return DIE_FIND_CB_CONTINUE;
> >  	else
> > 
> > 
> > 
> > 
> 
> 
> -- 
> Masami HIRAMATSU
> Software Platform Research Dept. Linux Technology Research Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 
