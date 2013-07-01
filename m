Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3GAOHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:07:25 -0400
Received: from dmz-mailsec-scanner-4.mit.edu ([18.9.25.15]:54370 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751499Ab3GAOHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:07:23 -0400
X-AuditID: 1209190f-b7fa58e000000953-93-51d18d1bcd60
Date: Mon, 1 Jul 2013 10:05:13 -0400
From: Greg Price <price@MIT.EDU>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf report: Add option to collapse undesired parts of
 call graph
Message-ID: <20130701140510.GC22203@biohazard-cafe.mit.edu>
References: <20121207072726.GY22203@biohazard-cafe.mit.edu>
 <20130111052736.GG3054@ghostprotocols.net>
 <20130623031720.GW22203@biohazard-cafe.mit.edu>
 <871u7p3bjb.fsf@sejong.aot.lge.com>
 <20130626222500.GZ22203@biohazard-cafe.mit.edu>
 <87obas176f.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obas176f.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsUixG6noivdezHQ4NNCPouLbRfZLA48PsBi
	sXXvGxaLo2f/Mllc3jWHzeLSgQVMFk3LtrJYrDmymN2Bw+PKUw6P0z16Hjtn3WX32LSqk83j
	/b6rbB5zd/UxenzeJBfAHsVlk5Kak1mWWqRvl8CV8ejcI7aCHSIVj7ouMzUwXuLvYuTkkBAw
	kVj8aAorhC0mceHeerYuRi4OIYF9jBJtjS1QzgZGicblc5ghnE+MEsc7dzGDtLAIqEgcnfCY
	BcRmE1CQ+DF/HVhcREBNYuX6WywgDcwCs5gk9jxbzQSSEBaIkJi++T/YPl4Ba4kv8xezQkyd
	wSQxsXMiE0RCUOLkzCdgU5kFtCRu/HsJFOcAsqUllv/jAAlzChhIvHpyhxHEFgU64tr+drYJ
	jIKzkHTPQtI9C6F7ASPzKkbZlNwq3dzEzJzi1GTd4uTEvLzUIl0TvdzMEr3UlNJNjKBY4ZTk
	38H47aDSIUYBDkYlHt4fMy8ECrEmlhVX5h5ilORgUhLlTeq+GCjEl5SfUpmRWJwRX1Sak1p8
	iFGCg1lJhPemN1CONyWxsiq1KB8mJc3BoiTO++zp2UAhgfTEktTs1NSC1CKYrAwHh5IEr3oP
	UKNgUWp6akVaZk4JQpqJgxNkOA/QcC+QGt7igsTc4sx0iPwpRkUpcV5+kIQASCKjNA+uF5bK
	XjGKA70izCsFUsUDTINw3a+ABjMBDeZtPQcyuCQRISXVwGipKHrRS9xq/9l1lvez7EOUX7c4
	L675Vv52tfWOS0r8a/YxBcTPyT68ZaLOPt07hx5rSNuZzKrhv/Lx+b/iDltvlqa5Z5XVKpQW
	K/l1qjsGn3lUMs2gxTF86dHmJHdxKWv/OVNm2SybWhYTp221LubS4bmGQWqxoUcOamt+eOXF
	YhYza+cMeyWW4oxEQy3mouJEABVEOL5AAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 01:58:16PM +0900, Namhyung Kim wrote:
> On Wed, 26 Jun 2013 18:25:01 -0400, Greg Price wrote:
> > On Wed, Jun 26, 2013 at 10:28:56AM +0900, Namhyung Kim wrote:
> >> On Sat, 22 Jun 2013 23:17:20 -0400, Greg Price wrote:
> >> > @@ -1211,8 +1214,13 @@ static int machine__resolve_callchain_sample(struct machine *machine,
> >> >  					   MAP__FUNCTION, ip, &al, NULL);
> >> >  		if (al.sym != NULL) {
> >> >  			if (sort__has_parent && !*parent &&
> >> > -			    symbol__match_parent_regex(al.sym))
> >> > +			    symbol__match_regex(al.sym, &parent_regex))
> >> >  				*parent = al.sym;
> >> > +			else if (have_blackbox && root_al &&
> >> > +			         symbol__match_regex(al.sym, &blackbox_regex)) {
> >> > +				*root_al = al;
> >> > +				callchain_cursor_reset(&callchain_cursor);
> >> 
> >> Okay, this is where the magic happens. :)
> >
> > Indeed! :)
> >
> >> So it overwrites the original 'al' in process_sample_event() to
> >> blackboxed symbol and drop the callchain.  Wouldn't it deserve a
> >> comment? :)
> >
> > I could do that.  Perhaps something like
> >   /* ignore the callchain we had so far, i.e. this symbol's callees */
> > Sound like what you had in mind?
> 
> More important thing is, I think, it updates the original al (root_al)
> so that the perf will see the new symbol as if it was sampled in the
> first place and it will collect all of its callers in one place.

OK, I'll try to capture that in a comment in v2.



> >> > +			}
> >> >  			if (!symbol_conf.use_callchain)
> >> >  				break;
> >> pp
> >> This is unrelated to this patch, but why is this line needed?  I guess
> >> this check should be done before calling this function.
> >
> > Hmm.  We actually can get into this function when
> > !symbol_conf.use_callchain, if we're using say --sort=parent.  But I'm
> > still somewhat puzzled, because in that case it looks like we'll break
> > the loop after the first address with a symbol, even if we didn't find
> > the 'parent' there, which seems like it wouldn't serve the purpose.
> 
> Right, that's what I want to say.
> 
> We already have the check before calling this function so breaking the
> loop after checking only first callchain node looks strange.  If we
> don't want to see callchains but only parents, it should either check
> every callchain nodes or fail out as an unsupported operation IMHO.

I agree.  Will reply momentarily with a patch.

I actually wrote a version that tries to keep the optimization, but
decided it was too complicated for what it gains us.

Cheers,
Greg
