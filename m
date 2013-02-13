Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874Ab3BMVRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:17:51 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41401 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab3BMVRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:17:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
References: <87621w14vs.fsf@xmission.com>
	<1360777934-5663-1-git-send-email-ebiederm@xmission.com>
	<1360777934-5663-48-git-send-email-ebiederm@xmission.com>
	<20130213203528.GN14195@fieldses.org>
Date: Wed, 13 Feb 2013 13:17:37 -0800
In-Reply-To: <20130213203528.GN14195@fieldses.org> (J. Bruce Fields's message
	of "Wed, 13 Feb 2013 15:35:28 -0500")
Message-ID: <87fw0zrk0e.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+YMki6ywL0q3T4xoFv9YW5rf5i+mVYL8c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0631]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;"J. Bruce Fields" <bfields@fieldses.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 48/85] sunrpc: Update gss uid to security context mapping.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

> On Wed, Feb 13, 2013 at 09:51:37AM -0800, Eric W. Biederman wrote:
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> - Use from_kuid when generating the on the wire uid values.
>> - Use make_kuid when reading on the wire values.
>> 
>> In gss_encode_v0_msg, since the uid in gss_upcall_msg is now a kuid_t
>> generate the necessary uid_t value on the stack copy it into
>> gss_msg->databuf where it can safely live until the message is no
>> longer needed.
>
> Apologies, I haven't been following the user namespace work.
>
> If I understand correctly, you're expecting the id's seen in nfs
> protocol messages to be the same as the id's seen in the initial user
> namespace.
>
> Why is that right, and not, say, the user namespace in which the mount
> was originally performed?  (Just asking, I honestly haven't thought
> about it before.)

Actually my expectation is the user namespace was originally performed
in.  Currently nfs doesn't support being  mounted in anything other
than the initial user namespace.

> Also:
>
>> diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
>> index afbbcfb..a360067 100644
>> --- a/net/sunrpc/auth_gss/auth_gss.c
>> +++ b/net/sunrpc/auth_gss/auth_gss.c
>> @@ -395,8 +395,11 @@ gss_upcall_callback(struct rpc_task *task)
>>  
>>  static void gss_encode_v0_msg(struct gss_upcall_msg *gss_msg)
>>  {
>> -	gss_msg->msg.data = &gss_msg->uid;
>> -	gss_msg->msg.len = sizeof(gss_msg->uid);
>> +	uid_t uid = from_kuid(&init_user_ns, gss_msg->uid);
>> +	memcpy(gss_msg->databuf, &uid, sizeof(uid));
>> +	gss_msg->msg.data = gss_msg->databuf;
>> +	gss_msg->msg.len = sizeof(uid);
>> +	BUG_ON(sizeof(uid) > UPCALL_BUF_LEN);
>
> This message is going to gssd, not to the server.  Should it be encoded
> for whatever namespace gssd lives in?

Good basic question.  The immediate answer is that right now I only
support these things living in user namespace the filesystem was
mounted in, aka the initial user namespace.

There are a handful of things ioctls, and a quota call or two that I
will translate into the callers user namespace.  For network filesystems
and their specialized helpers it would be lossy and unnecessarily
complex to support arbitrary pieces living in different user namespaces.
Historically unix has had syncrhonized password databases to ensure even
multiple machines effectively had the same user namespace.

The really important step for me is to have the kernel using kuid_t and
kgid_t throughout and only converting when talking outside of the kernel
(disk, filesystem on disk data structures, network).

With that step I can enable user namespaces and the various filesystems.
And even if the filesystem itself is restricted to just one user
namespace, the users who read and write files on that filesystem won't
be.

A next step for the filesystems where this is interesting is to support
a user who is not the global root mounting the filesystem and having the
filesystem speak in ids in the user namespace that the filesystem was
mounted in.  That takes a little bit of connecting the dots of which
user namespace goes where, and it takes a little bit of confidence that
the kernel won't fall over if an evil server sends us deliberately bad
protocol messages.  I suspect at some point someone will want to figure
all of that out for nfs, certainly there has been work to figure that
out for network namespaces.

For now though I am happy to have kuid_t and kgid_t pushed down
everywhere they should be.

Eric
