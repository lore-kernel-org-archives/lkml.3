Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771Ab3BMV3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:29:46 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56536 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3BMV3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:29:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
References: <87621w14vs.fsf@xmission.com>
	<1360777934-5663-1-git-send-email-ebiederm@xmission.com>
	<1360777934-5663-52-git-send-email-ebiederm@xmission.com>
	<20130213210545.GO14195@fieldses.org>
Date: Wed, 13 Feb 2013 13:29:35 -0800
In-Reply-To: <20130213210545.GO14195@fieldses.org> (J. Bruce Fields's message
	of "Wed, 13 Feb 2013 16:05:45 -0500")
Message-ID: <874nhfrjgg.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18xMx+4ULk3HLgsV/Rw/7so/tYHGFsMPOU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2612]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;"J. Bruce Fields" <bfields@fieldses.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 52/85] sunrpc: Properly encode kuids and kgids in auth.unix.gid rpc pipe upcalls.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

> On Wed, Feb 13, 2013 at 09:51:41AM -0800, Eric W. Biederman wrote:
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> When a new rpc connection is established with an in-kernel server, the
>> traffic passes through svc_process_common, and svc_set_client and down
>> into svcauth_unix_set_client if it is of type RPC_AUTH_NULL or
>> RPC_AUTH_UNIX.
>> 
>> svcauth_unix_set_client then looks at the uid of the credential we
>> have assigned to the incomming client and if we don't have the groups
>> already cached makes an upcall to get a list of groups that the client
>> can use.
>> 
>> The upcall encodes send a rpc message to user space encoding the uid
>> of the user whose groups we want to know.  Encode the kuid of the user
>> in the initial user namespace as nfs mounts can only happen today in
>> the initial user namespace.
>
> OK, I didn't know that.
>
> (Though I'm unclear how it should matter to the server what user
> namespace the client is in?)

Perhaps I have the description a little scrambled.  The short version
is that to start I only support the initial network namespace.

If I haven't succeeded it is my intent to initially limit the servers
to the initial user namespace as well.  I should see if I can figure
that out.

>> When a reply to an upcall comes in convert interpret the uid and gid values
>> from the rpc pipe as uids and gids in the initial user namespace and convert
>> them into kuids and kgids before processing them further.
>> 
>> When reading proc files listing the uid to gid list cache convert the
>> kuids and kgids from into uids and gids the initial user namespace.  As we are
>> displaying server internal details it makes sense to display these values
>> from the servers perspective.
>
> All of these caches are already per-network-namespace.  Ideally wouldn't
> we also like to associate a user namespace with each cache somehow?

Ideally yes.  I read through the caches enough to figure out where there
user space interfaces were, and to make certain we had conversions
to/from kuids and kgids.

I haven't looked at what user namespace makes sense for these
caches.  For this cache my first guess is that net->user_ns
is what we want as it will be shared by all users in network namespace I
presume.

Eric
