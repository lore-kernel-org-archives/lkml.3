Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765592Ab3DKU7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:59:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7537 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250Ab3DKU7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:59:37 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=NW3GVE8-lwgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=wPiHxgUD27cA:10 a=PtDNVHqPAAAA:8 a=VwQbUJbxAAAA:8 a=DfNHnWVPAAAA:8 a=f4EkgSaEAAAA:8 a=ga_zVJg9VVrRIAkWp5wA:9 a=QEXdDO2ut3YA:10 a=4Jd3rJXRXSUA:10 a=jeBq3FmKZ4MA:10 a=wYE_KDyynt4A:10 a=lBRciGGoxdUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365713976.9609.63.camel@gandalf.local.home>
Subject: Re: [ 111/171 ] ipc: Restrict mounting the mqueue filesystem
From: Steven Rostedt <rostedt@goodmis.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Date: Thu, 11 Apr 2013 16:59:36 -0400
In-Reply-To: <8738uwvlb7.fsf@xmission.com>
References: <20130411202503.783159048@goodmis.org>
	 <20130411202604.512616100@goodmis.org> <8738uwvlb7.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 13:55 -0700, Eric W. Biederman wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > 3.6.11.2 stable review patch.
> > If anyone has any objections, please let me know.
> 
> Mounting only with privilege in the user namespace only dates
> back to 3.8 so this is not needed in 3.6.

Hmm, I didn't see anything in the change log to suggest that.

If a patch applies, and there's nothing in the change log that tells me
that it shouldn't be added, I add it ;-)

> 
> Not that it should do any harm.

OK, then, I guess I'll just keep it.

Thanks,

-- Steve

> 
> Eric
> 
> > ------------------
> >
> > From: "Eric W. Biederman" <ebiederm@xmission.com>
> >
> > [ Upstream commit a636b702ed1805e988ad3d8ff8b52c060f8b341c ]
> >
> > Only allow mounting the mqueue filesystem if the caller has CAP_SYS_ADMIN
> > rights over the ipc namespace.   The principle here is if you create
> > or have capabilities over it you can mount it, otherwise you get to live
> > with what other people have mounted.
> >
> > This information is not particularly sensitive and mqueue essentially
> > only reports which posix messages queues exist.  Still when creating a
> > restricted environment for an application to live any extra
> > information may be of use to someone with sufficient creativity.  The
> > historical if imperfect way this information has been restricted has
> > been not to allow mounts and restricting this to ipc namespace
> > creators maintains the spirit of the historical restriction.
> >
> > Cc: stable@vger.kernel.org
> > Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> > Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  ipc/mqueue.c |   12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> > index 9e4cf7f..f1df4bc 100644
> > --- a/ipc/mqueue.c
> > +++ b/ipc/mqueue.c
> > @@ -331,8 +331,16 @@ static struct dentry *mqueue_mount(struct file_system_type *fs_type,
> >  			 int flags, const char *dev_name,
> >  			 void *data)
> >  {
> > -	if (!(flags & MS_KERNMOUNT))
> > -		data = current->nsproxy->ipc_ns;
> > +	if (!(flags & MS_KERNMOUNT)) {
> > +		struct ipc_namespace *ns = current->nsproxy->ipc_ns;
> > +		/* Don't allow mounting unless the caller has CAP_SYS_ADMIN
> > +		 * over the ipc namespace.
> > +		 */
> > +		if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN))
> > +			return ERR_PTR(-EPERM);
> > +
> > +		data = ns;
> > +	}
> >  	return mount_ns(fs_type, flags, data, mqueue_fill_super);
> >  }


