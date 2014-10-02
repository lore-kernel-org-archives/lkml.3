Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaJBVIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:08:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42152 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaJBVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:08:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        akpm@linux-foundation.org, rui.xiang@huawei.com,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gorcunov@openvz.org,
        kirill.shutemov@linux.intel.com, grant.likely@secretlab.ca,
        tytso@mit.edu, Thierry Herbelot <thierry.herbelot@6wind.com>
References: <20131003.150947.2179820478039260398.davem@davemloft.net>
	<1412263501-6572-1-git-send-email-nicolas.dichtel@6wind.com>
	<1412263501-6572-3-git-send-email-nicolas.dichtel@6wind.com>
	<87h9zmpcz5.fsf@x220.int.ebiederm.org>
	<20141002200639.GA3497@p183.telecom.by>
Date: Thu, 02 Oct 2014 14:07:37 -0700
In-Reply-To: <20141002200639.GA3497@p183.telecom.by> (Alexey Dobriyan's
	message of "Thu, 2 Oct 2014 23:06:39 +0300")
Message-ID: <87h9zmji3q.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19EzPWWBVskhk0rFtAPJ9KHaMxLQ3LfXJM=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4512]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Dobriyan <adobriyan@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1122 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 2.9 (0.3%), b_tie_ro: 2.0 (0.2%), parse: 1.03 (0.1%),
	extract_message_metadata: 41 (3.7%), get_uri_detail_list: 2.5 (0.2%),
	tests_pri_-1000: 27 (2.4%), tests_pri_-950: 10 (0.9%), tests_pri_-900: 1.45
	(0.1%), tests_pri_-400: 71 (6.3%), check_bayes: 69 (6.1%), b_tokenize: 26
	(2.3%), b_tok_get_all: 23 (2.1%), b_comp_prob: 3.5 (0.3%), b_tok_touch_all:
	2.2 (0.2%), b_finish: 0.70 (0.1%), tests_pri_0: 947 (84.4%), tests_pri_500:
	17 (1.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH linux 2/2] fs/proc: use a hash table for the directory entries
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On Thu, Oct 02, 2014 at 11:01:50AM -0700, Eric W. Biederman wrote:
>> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>> 
>> > From: Thierry Herbelot <thierry.herbelot@6wind.com>
>> >
>> > The current implementation for the directories in /proc is using a single
>> > linked list. This is slow when handling directories with large numbers of
>> > entries (eg netdevice-related entries when lots of tunnels are opened).
>> >
>> > This patch enables multiple linked lists. A hash based on the entry name is
>> > used to select the linked list for one given entry.
>> >
>> > The speed creation of netdevices is faster as shorter linked lists must be
>> > scanned when adding a new netdevice.
>> 
>> Is the directory of primary concern /proc/net/dev/snmp6 ?
>> 
>> Unless I have configured my networking stack weird by mistake that
>> is the only directory under /proc/net that grows when we add an
>> interface.
>> 
>> I just want to make certain I am seeing the same things that you are
>> seeing.
>> 
>> I feel silly for overlooking this directory when the rest of the
>> scalability work was done.
>
> Slowdown comes from "duplicate name" check:
>
>         for (tmp = dir->subdir; tmp; tmp = tmp->next)
>                 if (strcmp(tmp->name, dp->name) == 0) {
>                         WARN(1, "proc_dir_entry '%s/%s' already registered\n",
>                                 dir->name, dp->name);
>                         break;
>                 }
>
> Removal can be made O(1) after switching to doubly-linked list.

Yes.  There is the however unfortunate fact that proc directories exist
to be used.  If we don't switch to a better data structure than a linked
list the actual use will then opening of the files under
/proc/net/dev/snmp6/ will become O(N^2).  Which doesn't help much
(assuming those files are good for something).

If those files aren't actually useful we should just make registering
them a config option.  Deprecate them strongly and let only people who
need extreme backwards compatibility enable them.

Alexey do you know that those files aren't useful?  Unless we know
otherwise we should make those files useful.

Eric

