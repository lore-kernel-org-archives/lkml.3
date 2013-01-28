Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3A1IGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:06:10 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40812 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3A1IGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:06:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lord Glauber Costa of Sealand <glommer@parallels.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <87ehh8it9s.fsf@xmission.com> <87txq4hedl.fsf@xmission.com>
	<51062AB5.9060203@parallels.com>
Date: Mon, 28 Jan 2013 00:05:57 -0800
In-Reply-To: <51062AB5.9060203@parallels.com> (Lord Glauber Costa of Sealand's
	message of "Mon, 28 Jan 2013 11:37:25 +0400")
Message-ID: <874ni1vije.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Wvwooo7ZUq1pRG+GEXlvOm+SocbOm1FQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lord Glauber Costa of Sealand <glommer@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 3/6] userns: Recommend use of memory control groups.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lord Glauber Costa of Sealand <glommer@parallels.com> writes:

> On 01/26/2013 06:22 AM, Eric W. Biederman wrote:
>> 
>> In the help text describing user namespaces recommend use of memory
>> control groups.  In many cases memory control groups are the only
>> mechanism there is to limit how much memory a user who can create
>> user namespaces can use.
>> 
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  Documentation/namespaces/resource-control.txt |   10 ++++++++++
>>  init/Kconfig                                  |    7 +++++++
>>  2 files changed, 17 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/namespaces/resource-control.txt
>> 
>> diff --git a/Documentation/namespaces/resource-control.txt b/Documentation/namespaces/resource-control.txt
>> new file mode 100644
>> index 0000000..3d8178a
>> --- /dev/null
>> +++ b/Documentation/namespaces/resource-control.txt
>> @@ -0,0 +1,10 @@
>> +There are a lot of kinds of objects in the kernel that don't have
>> +individual limits or that have limits that are ineffective when a set
>> +of processes is allowed to switch user ids.  With user namespaces
>> +enabled in a kernel for people who don't trust their users or their
>> +users programs to play nice this problems becomes more acute.
>> +
>> +Therefore it is recommended that memory control groups be enabled in
>> +kernels that enable user namespaces, and it is further recommended
>> +that userspace configure memory control groups to limit how much
>> +memory users they don't trust to play nice can use.
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 7d30240..c8c58bd 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -1035,6 +1035,13 @@ config USER_NS
>>  	help
>>  	  This allows containers, i.e. vservers, to use user namespaces
>>  	  to provide different user info for different servers.
>> +
>> +	  When user namespaces are enabled in the kernel it is
>> +	  recommended that the MEMCG and MEMCG_KMEM options also be
>> +	  enabled and that user-space use the memory control groups to
>> +	  limit the amount of memory a memory unprivileged users can
>> +	  use.
>> +
>>  	  If unsure, say N.
>
> Since this becomes an official recommendation that people will likely
> follow, are we really that much concerned about the types of abuses the
> MEMCG_KMEM will prevent? Those are mostly metadata-based abuses users
> could do in their own local disks without mounting anything extra (and
> things that look like that)
>
> Unless there is a specific concern here, shouldn't we say "... that the
> MEMCG (and possibly MEMCG_KMEM) options..." ?

There are quite a few specific concerns.  The easiest to spot is
unshare(CLONE_NEWUSER), and the other namespaces.  Then there are
network devices.  Then there is I don't know what else.

Most distro's don't seem to care at all about limiting a users memory
so in that sense it is not a concern.

On the other hand for everyone who wants to limit a user's memory the
only way that is going to happen in a reasonable amount of
implementation time is with memory control groups, and slabs and kmalloc
are most definitely part of the memory needs to be limited.

Eric
