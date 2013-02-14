Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3BNImc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 03:42:32 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35436 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab3BNIma convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 03:42:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, <linux-fsdevel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
References: <87621w14vs.fsf@xmission.com>
	<1360777934-5663-1-git-send-email-ebiederm@xmission.com>
	<1360777934-5663-52-git-send-email-ebiederm@xmission.com>
	<20130213210545.GO14195@fieldses.org> <874nhfrjgg.fsf@xmission.com>
	<20130213215047.GR14195@fieldses.org> <8738wzq1z6.fsf@xmission.com>
	<20130213225840.GV14195@fieldses.org> <87ip5vn6iv.fsf@xmission.com>
	<511C8E50.8080007@parallels.com>
Date: Thu, 14 Feb 2013 00:42:20 -0800
In-Reply-To: <511C8E50.8080007@parallels.com> (Stanislav Kinsbursky's message
	of "Thu, 14 Feb 2013 11:12:16 +0400")
Message-ID: <877gmbguc3.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1+LSRW75tqRB05H1KI/hVhJRj3ydGoMW/s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1149]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Stanislav Kinsbursky <skinsbursky@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 52/85] sunrpc: Properly encode kuids and kgids in auth.unix.gid rpc pipe upcalls.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Kinsbursky <skinsbursky@parallels.com> writes:

> 14.02.2013 03:22, Eric W. Biederman пишет:

> Hmmm...
> Maybe I'm missing the point of user namespaces, but since NFS kernel server
> is controlled via NFSd file system write calls, maybe it would be better to add:
>
> .fs_flags = FS_USERNS_MOUNT
>
> to it and add check:
>
> +	if (net->user_ns != current_user_ns())
> +		return -EINVAL;
>
> No?

Not really.  The immediate goal is to just use kuid_t and kgid_t instead
of uid_t and gid_t throughout the kernel.  That ensures someone hasn't
missed a case and is getting a uid in one namespace confused with a uid
in another.  And that is needed to make it safe to enable nfs and nfsd
support when user namespace support is enabled in the kernel.

So at the basic level I have made the assumption that all nfs activity
happens in the initial user namespace and have made conversions to/from
the initial user namespace throughout the nfs and nfsd code.

We can add FS_USERNS_MOUNT when we are ready to support running in
multiple user namespaces.  For now not allowing mounts outside of the
initial user namespace ensures that the nfs client code is always
in the initial user namespace and that the nfs server code is always
dealing with ids in the initial user namespace.

Stanislav even with your pending patches it won't be possible to mount a
nfsd whre net->user_ns != init_userns.  So no bugs will result in the
combination of our patches.  The one case I was worried about was
fs/nfs/exports.  But since that is read-only it creates no problems.


The big things user namespaces allow (besides uid and gid mapping) is a
context where unprivileged users can create containers.  Those
containers can mount and unmount filesystems and have a root user.  But
that root users does not have global uid == 0, nor does that root user
have any global capabilities.  The root user only has capabilities over
objects created in that user namespace.  Which can include network
namespaces etc.




Now all of that said and done when we do start supporting user
namespaces in nfs (something that looks comparitively simple after your
recent work to make nfs and nfsd network namespace aware) I expect the
mount for nfsd and nfs will want to do:
	if (net->user_ns != current_user_ns())
        	return -EINVAL;

I can't see any other cases actually making sense.  If we are in an
ancestor user namespace of net->user_ns we are ok permission wise
but totally we are in a totally confused state with respect to which
permission to talk.  If we are in a descendent user namespace we should
not have the permissions to potentially dangerous things.

Which should make for a very very simple conversion when to get nfs
running in multiple user namespaces for 3.10 as we can just replace
&init_net with net->user_ns everywhere.

Eric
