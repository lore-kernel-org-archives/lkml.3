Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740Ab3BMVYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:24:19 -0500
Received: from fieldses.org ([174.143.236.118]:39375 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760614Ab3BMVYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:24:17 -0500
Date: Wed, 13 Feb 2013 16:24:15 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH review 48/85] sunrpc: Update gss uid to security context
 mapping.
Message-ID: <20130213212415.GP14195@fieldses.org>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
 <1360777934-5663-48-git-send-email-ebiederm@xmission.com>
 <20130213203528.GN14195@fieldses.org>
 <87fw0zrk0e.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw0zrk0e.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 01:17:37PM -0800, Eric W. Biederman wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> > On Wed, Feb 13, 2013 at 09:51:37AM -0800, Eric W. Biederman wrote:
> >> From: "Eric W. Biederman" <ebiederm@xmission.com>
> >> 
> >> - Use from_kuid when generating the on the wire uid values.
> >> - Use make_kuid when reading on the wire values.
> >> 
> >> In gss_encode_v0_msg, since the uid in gss_upcall_msg is now a kuid_t
> >> generate the necessary uid_t value on the stack copy it into
> >> gss_msg->databuf where it can safely live until the message is no
> >> longer needed.
> >
> > Apologies, I haven't been following the user namespace work.
> >
> > If I understand correctly, you're expecting the id's seen in nfs
> > protocol messages to be the same as the id's seen in the initial user
> > namespace.
> >
> > Why is that right, and not, say, the user namespace in which the mount
> > was originally performed?  (Just asking, I honestly haven't thought
> > about it before.)
> 
> Actually my expectation is the user namespace was originally performed
> in.  Currently nfs doesn't support being  mounted in anything other
> than the initial user namespace.
> 
> > Also:
> >
> >> diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> >> index afbbcfb..a360067 100644
> >> --- a/net/sunrpc/auth_gss/auth_gss.c
> >> +++ b/net/sunrpc/auth_gss/auth_gss.c
> >> @@ -395,8 +395,11 @@ gss_upcall_callback(struct rpc_task *task)
> >>  
> >>  static void gss_encode_v0_msg(struct gss_upcall_msg *gss_msg)
> >>  {
> >> -	gss_msg->msg.data = &gss_msg->uid;
> >> -	gss_msg->msg.len = sizeof(gss_msg->uid);
> >> +	uid_t uid = from_kuid(&init_user_ns, gss_msg->uid);
> >> +	memcpy(gss_msg->databuf, &uid, sizeof(uid));
> >> +	gss_msg->msg.data = gss_msg->databuf;
> >> +	gss_msg->msg.len = sizeof(uid);
> >> +	BUG_ON(sizeof(uid) > UPCALL_BUF_LEN);
> >
> > This message is going to gssd, not to the server.  Should it be encoded
> > for whatever namespace gssd lives in?
> 
> Good basic question.  The immediate answer is that right now I only
> support these things living in user namespace the filesystem was
> mounted in, aka the initial user namespace.
> 
> There are a handful of things ioctls, and a quota call or two that I
> will translate into the callers user namespace.  For network filesystems
> and their specialized helpers it would be lossy and unnecessarily
> complex to support arbitrary pieces living in different user namespaces.
> Historically unix has had syncrhonized password databases to ensure even
> multiple machines effectively had the same user namespace.
> 
> The really important step for me is to have the kernel using kuid_t and
> kgid_t throughout and only converting when talking outside of the kernel
> (disk, filesystem on disk data structures, network).
> 
> With that step I can enable user namespaces and the various filesystems.
> And even if the filesystem itself is restricted to just one user
> namespace, the users who read and write files on that filesystem won't
> be.
> 
> A next step for the filesystems where this is interesting is to support
> a user who is not the global root mounting the filesystem and having the
> filesystem speak in ids in the user namespace that the filesystem was
> mounted in.  That takes a little bit of connecting the dots of which
> user namespace goes where, and it takes a little bit of confidence that
> the kernel won't fall over if an evil server sends us deliberately bad
> protocol messages.  I suspect at some point someone will want to figure
> all of that out for nfs, certainly there has been work to figure that
> out for network namespaces.
> 
> For now though I am happy to have kuid_t and kgid_t pushed down
> everywhere they should be.

OK, makes sense, thanks for the explanation.--b.
