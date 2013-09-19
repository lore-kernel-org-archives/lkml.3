Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3ISSYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:24:34 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:61029 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3ISSYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:24:32 -0400
Date: Thu, 19 Sep 2013 15:24:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3] perf: Support for Openembedded/Yocto -dbg packages
Message-ID: <20130919182421.GF17742@ghostprotocols.net>
References: <1379512574-25912-1-git-send-email-ricardo.ribalda@gmail.com>
 <CAPybu_3H9NkE4gh9oobu-xB2V=vjhAtD6uhvB5kAd8b9=gsigA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_3H9NkE4gh9oobu-xB2V=vjhAtD6uhvB5kAd8b9=gsigA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 19, 2013 at 07:03:43PM +0200, Ricardo Ribalda Delgado escreveu:
> Anything else to fix on this patch?

Not from a quick read, thanks for addressing the comments, I'll stash it
in my perf/core branch.

- Arnaldo
 
> On Wed, Sep 18, 2013 at 3:56 PM, Ricardo Ribalda Delgado
> <ricardo.ribalda@gmail.com> wrote:
> > On OpenEmbedded the symbol files are located under a .debug folder on
> > the same folder as the binary file.
> >
> > This patch adds support for such files.
> >
> > Without this patch on perf top you can see:
> >
> > no symbols found in /usr/lib/gstreamer-1.0/libtheoraenc.so.1.1.2, maybe install
> > a debug package?
> >
> > 84.56%  libtheoraenc.so.1.1.2       [.] 0x000000000000b346
> >
> > With this patch symbols are shown:
> >
> > 19.06%  libtheoraenc.so.1.1.2       [.] oc_int_frag_satd_thresh_mmxext
> > 9.76%   libtheoraenc.so.1.1.2       [.] oc_analyze_mb_mode_luma
> > 5.58%   libtheoraenc.so.1.1.2       [.] oc_qii_state_advance
> > 4.84%   libtheoraenc.so.1.1.2       [.] oc_enc_tokenize_ac
> > ...
> >
> > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> > ---
> >
> > v2: Changes proposed by Ingo Molnar
> >
> > -Improve changeset
> > -Improve multi-snprintf readability
> > -Code Style
> >
> > v3: Changes proposed by Ingo Molnar, Arnaldo Carvalho de Melo and Peter Zijlstra
> >
> > -Code Style
> > -Use scnprintf
> >
> >
> >  tools/perf/util/dso.c    | 49 +++++++++++++++++++++++++++++++++++-------------
> >  tools/perf/util/dso.h    |  1 +
> >  tools/perf/util/symbol.c |  1 +
> >  3 files changed, 38 insertions(+), 13 deletions(-)
> >
> > diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
> > index e3c1ff8..6bfc8aa 100644
> > --- a/tools/perf/util/dso.c
> > +++ b/tools/perf/util/dso.c
> > @@ -7,19 +7,20 @@
> >  char dso__symtab_origin(const struct dso *dso)
> >  {
> >         static const char origin[] = {
> > -               [DSO_BINARY_TYPE__KALLSYMS]             = 'k',
> > -               [DSO_BINARY_TYPE__VMLINUX]              = 'v',
> > -               [DSO_BINARY_TYPE__JAVA_JIT]             = 'j',
> > -               [DSO_BINARY_TYPE__DEBUGLINK]            = 'l',
> > -               [DSO_BINARY_TYPE__BUILD_ID_CACHE]       = 'B',
> > -               [DSO_BINARY_TYPE__FEDORA_DEBUGINFO]     = 'f',
> > -               [DSO_BINARY_TYPE__UBUNTU_DEBUGINFO]     = 'u',
> > -               [DSO_BINARY_TYPE__BUILDID_DEBUGINFO]    = 'b',
> > -               [DSO_BINARY_TYPE__SYSTEM_PATH_DSO]      = 'd',
> > -               [DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]  = 'K',
> > -               [DSO_BINARY_TYPE__GUEST_KALLSYMS]       = 'g',
> > -               [DSO_BINARY_TYPE__GUEST_KMODULE]        = 'G',
> > -               [DSO_BINARY_TYPE__GUEST_VMLINUX]        = 'V',
> > +               [DSO_BINARY_TYPE__KALLSYMS]                     = 'k',
> > +               [DSO_BINARY_TYPE__VMLINUX]                      = 'v',
> > +               [DSO_BINARY_TYPE__JAVA_JIT]                     = 'j',
> > +               [DSO_BINARY_TYPE__DEBUGLINK]                    = 'l',
> > +               [DSO_BINARY_TYPE__BUILD_ID_CACHE]               = 'B',
> > +               [DSO_BINARY_TYPE__FEDORA_DEBUGINFO]             = 'f',
> > +               [DSO_BINARY_TYPE__UBUNTU_DEBUGINFO]             = 'u',
> > +               [DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO]       = 'o',
> > +               [DSO_BINARY_TYPE__BUILDID_DEBUGINFO]            = 'b',
> > +               [DSO_BINARY_TYPE__SYSTEM_PATH_DSO]              = 'd',
> > +               [DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]          = 'K',
> > +               [DSO_BINARY_TYPE__GUEST_KALLSYMS]               = 'g',
> > +               [DSO_BINARY_TYPE__GUEST_KMODULE]                = 'G',
> > +               [DSO_BINARY_TYPE__GUEST_VMLINUX]                = 'V',
> >         };
> >
> >         if (dso == NULL || dso->symtab_type == DSO_BINARY_TYPE__NOT_FOUND)
> > @@ -64,6 +65,28 @@ int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
> >                          symbol_conf.symfs, dso->long_name);
> >                 break;
> >
> > +       case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:
> > +       {
> > +               char *last_slash;
> > +               size_t len;
> > +               size_t dir_size;
> > +
> > +               last_slash = dso->long_name + dso->long_name_len;
> > +               while (last_slash != dso->long_name && *last_slash != '/')
> > +                       last_slash--;
> > +
> > +               len = scnprintf(file, size, "%s", symbol_conf.symfs);
> > +               dir_size = last_slash - dso->long_name + 2;
> > +               if (dir_size > (size - len)) {
> > +                       ret = -1;
> > +                       break;
> > +               }
> > +               len += scnprintf(file + len, dir_size, "%s",  dso->long_name);
> > +               len += scnprintf(file + len , size - len, ".debug%s",
> > +                                                               last_slash);
> > +               break;
> > +       }
> > +
> >         case DSO_BINARY_TYPE__BUILDID_DEBUGINFO:
> >                 if (!dso->has_build_id) {
> >                         ret = -1;
> > diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
> > index b793053..dbd9241 100644
> > --- a/tools/perf/util/dso.h
> > +++ b/tools/perf/util/dso.h
> > @@ -23,6 +23,7 @@ enum dso_binary_type {
> >         DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
> >         DSO_BINARY_TYPE__KCORE,
> >         DSO_BINARY_TYPE__GUEST_KCORE,
> > +       DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
> >         DSO_BINARY_TYPE__NOT_FOUND,
> >  };
> >
> > diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> > index 7eb0362..cd1dcc4 100644
> > --- a/tools/perf/util/symbol.c
> > +++ b/tools/perf/util/symbol.c
> > @@ -51,6 +51,7 @@ static enum dso_binary_type binary_type_symtab[] = {
> >         DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
> >         DSO_BINARY_TYPE__GUEST_KMODULE,
> >         DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
> > +       DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
> >         DSO_BINARY_TYPE__NOT_FOUND,
> >  };
> >
> > --
> > 1.8.4.rc3
> >
> 
> 
> 
> -- 
> Ricardo Ribalda
