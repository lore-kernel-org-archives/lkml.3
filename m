Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbaDQJ5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:57:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825AbaDQJ4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:56:52 -0400
Date: Thu, 17 Apr 2014 11:56:33 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrien BAK <adrien.bak@metascale.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Error reporting improvement
Message-ID: <20140417095632.GA1382@krava.brq.redhat.com>
References: <534E3215.2060306@metascale.org>
 <20140416142405.GC2005@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416142405.GC2005@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 03:24:05PM +0100, Will Deacon wrote:
> Hi Adrien,
> 
> On Wed, Apr 16, 2014 at 08:32:37AM +0100, Adrien BAK wrote:
> > In the current version, when using perf record, if something goes wrong in
> > tools/perf/builtin-record.c:375  session = perf_session__new(file, 
> > false, NULL);
> > The error message:
> > "Not enough memory for reading per file header"
> > is issued. This error message seems to be outdated and is not very helpful.
> > This patch propose to replace this error message by
> > "Perf session creation failed"
> > 
> > I believe this issue has been brought to lkml :
> > https://lkml.org/lkml/2014/2/24/458
> > although this patch only tackle a (small) part of the issue.
> > 
> > Additionnaly, this patch improves error reporting in
> > tools/perf/util/data.c open_file_write
> > Currently, if the call to open fails, the user is unaware of it.
> > This patch logs the error, before returning the error code to the caller.
> > 
> > Signed-off-by: Adrien BAK <adrien.bak@metascale.org>
> 
> Whilst this patch (admittedly) only solves part of the problem, I think it
> makes the error I encountered a lot easier to understand.
> 
> Thanks,
> 
>   Reported-by: Will Deacon <will.deacon@arm.com>

seems ok to me, but the patch is mangled:

[jolsa@krava perf]$ git am /tmp/b
Applying: Error reporting improvement
fatal: corrupt patch at line 7
Patch failed at 0001 Error reporting improvement
The copy of the patch that failed is found in:
   /home/jolsa/kernel.org/linux-perf/.git/rebase-apply/patch
When you have resolved this problem, run "git am --resolved".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

[jolsa@krava perf]$ patch -p3 < /tmp/b1 
patching file builtin-record.c
patch: **** malformed patch at line 87: argc, const char **argv)

please check Documentation/email-clients.txt and resend

thanks,
jirka

> 
> Will
> 
> > 
> > ---
> > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > index eb524f9..8ce62ef 100644
> > --- a/tools/perf/builtin-record.c
> > +++ b/tools/perf/builtin-record.c
> > @@ -374,7 +374,7 @@ static int __cmd_record(struct record *rec, int 
> > argc, const char **argv)
> > 
> >       session = perf_session__new(file, false, NULL);
> >       if (session == NULL) {
> > -        pr_err("Not enough memory for reading perf file header\n");
> > +        pr_err("Perf session creation failed.\n");
> >           return -1;
> >       }
> > 
> > diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
> > index 1fbcd8b..ff2ced7 100644
> > --- a/tools/perf/util/data.c
> > +++ b/tools/perf/util/data.c
> > @@ -86,10 +86,16 @@ static int open_file_read(struct perf_data_file *file)
> > 
> >   static int open_file_write(struct perf_data_file *file)
> >   {
> > +    int fd;
> >       if (check_backup(file))
> >           return -1;
> > 
> > -    return open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
> > +    fd = open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
> > +
> > +    if (fd < 0)
> > +        pr_err("failed to open %s : %s\n", file->path, strerror(errno));
> > +
> > +    return fd;
> >   }
> > 
> >   static int open_file(struct perf_data_file *file)
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
