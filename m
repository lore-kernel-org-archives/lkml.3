Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaJBSCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:02:22 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39466 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJBSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:02:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        akpm@linux-foundation.org, adobriyan@gmail.com, rui.xiang@huawei.com,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gorcunov@openvz.org,
        kirill.shutemov@linux.intel.com, grant.likely@secretlab.ca,
        tytso@mit.edu, Thierry Herbelot <thierry.herbelot@6wind.com>
References: <20131003.150947.2179820478039260398.davem@davemloft.net>
	<1412263501-6572-1-git-send-email-nicolas.dichtel@6wind.com>
	<1412263501-6572-3-git-send-email-nicolas.dichtel@6wind.com>
Date: Thu, 02 Oct 2014 11:01:50 -0700
In-Reply-To: <1412263501-6572-3-git-send-email-nicolas.dichtel@6wind.com>
	(Nicolas Dichtel's message of "Thu, 2 Oct 2014 17:25:01 +0200")
Message-ID: <87h9zmpcz5.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Y4y3EO8f+ZEB+5cffYDs0HMTxdKcJHlU=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4997]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Nicolas Dichtel <nicolas.dichtel@6wind.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 394 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 2.8 (0.7%), b_tie_ro: 1.93 (0.5%), parse: 0.96 (0.2%),
	extract_message_metadata: 20 (5.0%), get_uri_detail_list: 5 (1.3%),
	tests_pri_-1000: 5 (1.3%), tests_pri_-950: 1.14 (0.3%), tests_pri_-900: 1.29
	(0.3%), tests_pri_-400: 30 (7.5%), check_bayes: 28 (7.1%), b_tokenize: 10
	(2.6%), b_tok_get_all: 9 (2.2%), b_comp_prob: 3.6 (0.9%), b_tok_touch_all:
	2.2 (0.6%), b_finish: 0.76 (0.2%), tests_pri_0: 325 (82.4%), tests_pri_500:
	4.5 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH linux 2/2] fs/proc: use a hash table for the directory entries
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:

> From: Thierry Herbelot <thierry.herbelot@6wind.com>
>
> The current implementation for the directories in /proc is using a single
> linked list. This is slow when handling directories with large numbers of
> entries (eg netdevice-related entries when lots of tunnels are opened).
>
> This patch enables multiple linked lists. A hash based on the entry name is
> used to select the linked list for one given entry.
>
> The speed creation of netdevices is faster as shorter linked lists must be
> scanned when adding a new netdevice.

Is the directory of primary concern /proc/net/dev/snmp6 ?

Unless I have configured my networking stack weird by mistake that
is the only directory under /proc/net that grows when we add an
interface.

I just want to make certain I am seeing the same things that you are
seeing.

I feel silly for overlooking this directory when the rest of the
scalability work was done.

> Here are some numbers:
>
> dummy30000.batch contains 30 000 times 'link add type dummy'.
>
> Before the patch:
> time ip -b dummy30000.batch
> real    2m32.221s
> user    0m0.380s
> sys     2m30.610s
>
> After the patch:
> time ip -b dummy30000.batch
> real    1m57.190s
> user    0m0.350s
> sys     1m56.120s
>
> The single 'subdir' list head is replaced by a subdir hash table. The subdir
> hash buckets are only allocated for directories. The number of hash buckets
> is a compile-time parameter.

That looks like a nice speed up.  A couple of things.

With sysfs and sysctl when faced this class of challenge we used an
rbtree instead of a hash table.  That should use less memory and scale
better.

I am concerned about a fixed sized hash table moving the location where
we fall off a cliff but not removing the cliff itself.

I suppose it would be possible to use the new fancy resizable hash
tables but previous work on sysctl and sysfs suggests that we don't look
up these entries sufficiently to require a hash table.  We just need a
data structure that doesn't fall over at scale, and the rbtrees seem to
do that very nicely.

> For all functions which handle directory entries, an additional check on the
> directory nature of the dir entry ensures that pde_hash_buckets was allocated.
> This check was not needed as subdir was present for all dir entries, whether
> actual directories or simple files.

That bit of logic seems reasonable.

Eric
