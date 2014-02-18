Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaBRUut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:50:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaBRUus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:50:48 -0500
Date: Tue, 18 Feb 2014 15:50:44 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH] audit: add arch field to seccomp event log
Message-ID: <20140218205044.GL16640@madcap2.tricolour.ca>
References: <4bc8c03bda84e004c331546e228b334811b03254.1392409147.git.rgb@redhat.com>
 <1392410961.2760.17.camel@localhost>
 <20140214205057.GF18807@madcap2.tricolour.ca>
 <20140214205218.GG18807@madcap2.tricolour.ca>
 <1392412322.2760.21.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392412322.2760.21.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/14, Eric Paris wrote:
> On Fri, 2014-02-14 at 15:52 -0500, Richard Guy Briggs wrote:
> > On 14/02/14, Richard Guy Briggs wrote:
> > > On 14/02/14, Eric Paris wrote:
> > > > On Fri, 2014-02-14 at 15:23 -0500, Richard Guy Briggs wrote:
> > > > > The AUDIT_SECCOMP record looks something like this:
> > > > > 
> > > > > type=SECCOMP msg=audit(1373478171.953:32775): auid=4325 uid=4325 gid=4325 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0 pid=12381 comm="test" sig=31 syscall=231 compat=0 ip=0x39ea8bca89 code=0x0
> > > > > 
> > > > > In order to determine what syscall 231 maps to, we need to have the arch= field right before it.
> > > > > 
> > > > > To see the event, compile this test.c program:
> > > > > 
> > > > > =====
> > > > > int main(void)
> > > > > {
> > > > >         return seccomp_load(seccomp_init(SCMP_ACT_KILL));
> > > > > }
> > > > > =====
> > > > > 
> > > > > gcc -g test.c -o test -lseccomp
> > > > > 
> > > > > After running the program, find the record by:  ausearch --start recent -m SECCOMP -i
> > > > > ---
> > > > >  kernel/auditsc.c |    1 +
> > > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > > > index 6874c1f..c464d44 100644
> > > > > --- a/kernel/auditsc.c
> > > > > +++ b/kernel/auditsc.c
> > > > > @@ -2412,6 +2412,7 @@ void __audit_seccomp(unsigned long syscall, long signr, int code)
> > > > >  		return;
> > > > >  	audit_log_task(ab);
> > > > >  	audit_log_format(ab, " sig=%ld", signr);
> > > > > +	audit_log_format(ab, " arch=%x", current->audit_context->arch);
> > > > 
> > > > 
> > > > What happens if the task does not have current->audit_context allocated?
> > > > Seems possible if signr is non-zero...
> > > 
> > > I had assumed that since we got this far, that there was an audit
> > > context.  This was my first patch:
> > 
> > Sorry, pulled the trigger too fast:
> > 
> > ---
> >  kernel/auditsc.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 6874c1f..3023d03 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2406,12 +2406,18 @@ void audit_core_dumps(long signr)
> >  void __audit_seccomp(unsigned long syscall, long signr, int code)
> >  {
> >         struct audit_buffer *ab;
> > +       struct audit_context *context audit_get_context(current, 0, 0);
> 
> missing '='   but this isn't what audit_get_context() does...   it's
> crappy naming...    I'd think a combo of audit_dummy_context() and
> current->audit_context would be most appropriate.

Ok.  I think I finally understand audit_dummy_context().  Thanks for the
hint.  However, it appears it is not useful in this sitation, since if
there is an audit_context, even a dummy context, it appears arch is
filled in.

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
@@ -2406,12 +2406,18 @@ void audit_core_dumps(long signr)
 void __audit_seccomp(unsigned long syscall, long signr, int code)
 {
 	struct audit_buffer *ab;
+	struct audit_context *context = current->audit_context;
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_SECCOMP);
 	if (unlikely(!ab))
 		return;
 	audit_log_task(ab);
 	audit_log_format(ab, " sig=%ld", signr);
+	audit_log_format(ab, " arch=");
+	if (context)
+		audit_log_format(ab, "%x", context->arch);
+	else
+		audit_log_format(ab, "(null)");
 	audit_log_format(ab, " syscall=%ld", syscall);
 	audit_log_format(ab, " compat=%d", is_compat_task());
 	audit_log_format(ab, " ip=0x%lx", KSTK_EIP(current));

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
