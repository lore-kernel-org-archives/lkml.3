Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3AZCbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 21:31:52 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:51538 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab3AZCbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 21:31:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Aristeu Rozanski <aris@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <20130123160221.GG17632@redhat.com>
	<20130124044438.GA13354@mail.hallyn.com>
	<20130124152859.GP17632@redhat.com>
	<20130124164612.af6de6f3.akpm@linux-foundation.org>
	<20130125140317.GS17632@redhat.com>
Date: Fri, 25 Jan 2013 18:31:37 -0800
In-Reply-To: <20130125140317.GS17632@redhat.com> (Aristeu Rozanski's message
	of "Fri, 25 Jan 2013 09:03:18 -0500")
Message-ID: <871ud8hdyu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19PUnl5ugRnPO8JAQvX8aFvGR6BYSyI8qM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4945]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Aristeu Rozanski <aris@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] userns: improve uid/gid map collision detection
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aristeu Rozanski <aris@redhat.com> writes:

> On Thu, Jan 24, 2013 at 04:46:12PM -0800, Andrew Morton wrote:
>> eek, a macro!  Macros are always bad.
>> 
>> This one is bad because
>> 
>> a) it's a macro
>> 
>> b) it evaluates its args multiple times and hence will cause nasty
>>    bugs if called with expressions-with-side-effects.
>> 
>> c) it evaluates its args multiple times and if called with
>>    non-trivial expressions the compiler might not be able to CSE those
>>    expressions, leading to code bloat.
>> 
>> Add lo, this patch:
>> 
>> --- a/kernel/user_namespace.c~userns-improve-uid-gid-map-collision-detection-fix
>> +++ a/kernel/user_namespace.c
>> @@ -521,7 +521,11 @@ struct seq_operations proc_projid_seq_op
>>  
>>  static DEFINE_MUTEX(id_map_mutex);
>>  
>> -#define in_range(b,first,len) ((b)>=(first)&&(b)<(first)+(len))
>> +static bool in_range(u32 b, u32 first, u32 len)
>> +{
>> +	return b >= first && b < first + len;
>> +}
>> +
>>  static inline int extent_collision(struct uid_gid_map *new_map,
>>  				   struct uid_gid_extent *extent)
>>  {
>> 
>> reduces the user_namespace.o text from 4822 bytes to 4727 with
>> gcc-4.4.4.  This is a remarkably large difference.
>
> thanks Andrew
>
> (I see Eric already answered about the config option)

Aritsteu after looking at both my version and yours I am going with
mine.  While my code is a little wordier I have half the number of
comparisons your code does, and I took the time to kill the variable
introducing a function to test for range collisions makes unnecessary.
On Andrews size metric my version seems noticably smaller as well.

 size $PWD-build/kernel/user_namespace.o
   text	   data	    bss	    dec	    hex	filename
   4376	    144	      0	   4520	   11a8	/home/eric/projects/linux/linux-userns-devel-build/kernel/user_namespace.o


Short of something unexpected I plan to push all my code to linux-next
sometime tomorrow.

Eric

