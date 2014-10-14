Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaJNT4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:56:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48242 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbaJNT4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:56:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: nicolas.dichtel@6wind.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        akpm@linux-foundation.org, adobriyan@gmail.com, rui.xiang@huawei.com,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gorcunov@openvz.org,
        kirill.shutemov@linux.intel.com, grant.likely@secretlab.ca,
        tytso@mit.edu, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20141006.181448.1696747135961247651.davem@davemloft.net>
	<1412672559-5256-1-git-send-email-nicolas.dichtel@6wind.com>
	<1412672559-5256-2-git-send-email-nicolas.dichtel@6wind.com>
	<543BB42B.30505@6wind.com>
Date: Tue, 14 Oct 2014 12:56:11 -0700
In-Reply-To: <543BB42B.30505@6wind.com> (Nicolas Dichtel's message of "Mon, 13
	Oct 2014 13:14:51 +0200")
Message-ID: <87y4sis9wk.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1/RoAOuvmeJYafEUC0CajCg5uCXKnYbuto=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4998]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.2 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;nicolas.dichtel@6wind.com
X-Spam-Relay-Country: 
X-Spam-Timing: total 463 ms - load_scoreonly_sql: 0.15 (0.0%),
	signal_user_changed: 4.7 (1.0%), b_tie_ro: 3.2 (0.7%), parse: 1.48 (0.3%),
	extract_message_metadata: 25 (5.4%), get_uri_detail_list: 2.8 (0.6%),
	tests_pri_-1000: 11 (2.4%), tests_pri_-950: 1.56 (0.3%), tests_pri_-900: 1.29
	(0.3%), tests_pri_-400: 35 (7.5%), check_bayes: 33 (7.2%), b_tokenize: 10
	(2.2%), b_tok_get_all: 14 (3.0%), b_comp_prob: 3.4 (0.7%), b_tok_touch_all:
	2.4 (0.5%), b_finish: 0.74 (0.2%), tests_pri_0: 373 (80.6%), tests_pri_500: 6
	(1.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH linux v3 1/1] fs/proc: use a rb tree for the directory entries
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:

> Le 07/10/2014 11:02, Nicolas Dichtel a écrit :
>> The current implementation for the directories in /proc is using a single
>> linked list. This is slow when handling directories with large numbers of
>> entries (eg netdevice-related entries when lots of tunnels are opened).
>>
>> This patch replaces this linked list by a red-black tree.
>>
>> Here are some numbers:
>>
>> dummy30000.batch contains 30 000 times 'link add type dummy'.
>>
>> Before the patch:
>> $ time ip -b dummy30000.batch
>> real	2m31.950s
>> user	0m0.440s
>> sys	2m21.440s
>> $ time rmmod dummy
>> real	1m35.764s
>> user	0m0.000s
>> sys	1m24.088s
>>
>> After the patch:
>> $ time ip -b dummy30000.batch
>> real	2m0.874s
>> user	0m0.448s
>> sys	1m49.720s
>> $ time rmmod dummy
>> real	1m13.988s
>> user	0m0.000s
>> sys	1m1.008s
>>
>> The idea of improving this part was suggested by
>> Thierry Herbelot <thierry.herbelot@6wind.com>.
>>
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>
> I'm not sure who is in charge of taking this patch. Should I resend it to
> someone else or is it already included in a tree?

There are a couple of things going on here.

This patch came out at the beginning of the merge window which is a time
when everything that was ready and well tested ahead of time gets
merged.

Your numbers don't look too bad, so I expect this code is ready to go
(although I am a smidge disappointed in the small size of the
performance improvement), my quick read through earlier did not show
anything scary.   Do you have any idea why going from O(N^2) algorithm
to a O(NlogN) algorithm showed such a small performance improvement with
30,000 entries?

Normally proc is looked at by a group of folks me, Alexey Dobriyan, and
Al Viro all sort of tag team taking care of the proc infrastructure with
(except for Al) Andrew Morton typically taking the patches and merging
them.

I am currently in the middle of a move so I don't have the time to carry
this change or do much of anything until I am settled again.

What I would recommend is verifying your patch works against v3.18-rc1
at the begginning of next week and sending the code to Andrew Morton.

Eric
