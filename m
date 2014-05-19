Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaESK2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:28:43 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58285 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaESK2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:28:40 -0400
X-AuditID: 85900ec0-d272ab9000001514-14-5379dcd4f872
Subject: [RFC PATCH 0/2] printk: Add context information to kernel messages
 from /dev/kmsg
To: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>,
        Petr Mladek <pmladek@suse.cz>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>
Date: Mon, 19 May 2014 19:28:35 +0900
Message-ID: <20140519102835.30455.10437.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch set adds context information to kernel messages from /dev/kmsg.

Two printk messages connected with KERN_CONT can be divided in multiple
lines by a different process context message. This induces two problems.

a) The owner problem
If the different context message seems like the 1st divided message, it is
difficult to understand which the 2nd divided message belongs to. This problem
can also occur for the situation where multiple message lines without KERN_CONT 
are broken into by similar messages. When user tools handle printk messages,
those mixed messages will create some inconveniences.

  - Example of the owner problem
	[110781.736171] sd 2:0:0:0: [sdb]  
	[110781.736170] sd 3:0:0:0: [sdc] Unhandled sense code
	[110781.736172] sd 3:0:0:0: [sdc]  
	[110781.736175] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
	[110781.736177] sd 3:0:0:0: [sdc]  
	[110781.736178] Sense Key : Medium Error [current] 
	[110781.736187] Sense Key : Recovered Error 

b) The reconstruction problem
Even if we solve the owner problem, we don't know the consecutive lines owned
by a particular context are whether divided messages with KERN_CONT or simply
separate lines from the beginning.

  - Example of the reconstruction problem
	[110781.736198] Read(10): 28 00
	 ...[snip]...
	[110781.736204]  00
	[110781.736205]  00 11 e0 00 01 00 00

	Which ones should be merged into on line? You may say the right answer,
	but it's difficult to automate. The expected result is as follows:

	[110781.736198] Read(10): 28 00 00 00 11 e0 00 01 00 00

We can consider three solutions for these problems:

1. Store continuous messages in a local buffer, and execute printk
 This does not induce fragment of messages. There are some related work about
 error messages in a SCSI layer.
	http://marc.info/?l=linux-scsi&m=135003083808290&w=2
	http://comments.gmane.org/gmane.linux.scsi/88768
 This approach will take time for acceptance activities because continuous
 printk is used in a lot of places. Moreover, this approach
 cannot solve the fragment message problem fundamentally, so kernel developers
 must always take care about continuous printk. Therefore, this solution takes a
 maintenance cost.

2. Add context information to all kernel messages
 This solves a) the owner problem because user tools can separate each
 owner message from mixed messages by the context information. If multiple
 message lines without KERN_CONT are broken into by similar messages, this is
 a good solution. However, this does not indicate which messages with KERN_CONT
 are fragmented, so this does not solve b) the reconstruction problem for those.

3. Apply 2. and add fragment flag to all fragmented kernel messages
 This solves a) and b) problems for multiple messages connected with KERN_CONT.
 The fragmented flag shows which messages with KERN_CONT are fragmented, so
 user tools can reconstruct to its original state by it after separating each
 owner message from mixed messages by the context information.
 
 This solves the fragment problem fundamentally by merging those fragment
 messages on userland, so this solution seems to be a right way. We choose this 
 solution.

Following description makes mention of only fragmented messages with KERN_CONT.
This is because if the problems for fragmented messages with KERN_CONT are
solved, the owner problem for the mixed messages without KERN_CONT is
also solved.

Fragment is induced by different process context messages, so we want to add
process context information to each message in order to connect fragmented
messages. CPU number is not sufficient because it can change while calling
a series of printks in the preemptive kernel. On the other hand, we don't want
to change results of dmesg and syslog messages. How do we tackle this problem?

The key idea is to change the header of /dev/kmsg. According to the
documentation of /dev/kmsg, we can add comma separated values before ';' as
the header information of /dev/kmsg. So, we can change the header information
based on the rule.

This patch set solves this problem by following two approaches:

1. Add process context information (PID/interrupt)
 Fragment can occur when the process context is different from the previous
 context stored in the cont buffer. By applying this 1st patch, the context
 information is indicated to connect fragment messages. Moreover, if the
 message is output in an interrupt context, the information is also output as
 s(softIRQ)/h(hardIRQ)/n(NMI).

2. Introduce an exact fragment flag
 Current kernel tries to add 'c' flag to the 1st fragmented line and '+' to
 the following fragmented lines. However, these flags are just a hint; it
 doesn't guarantee that they are always correct because the kernel can't know
 the right answer without context information. Current kernel adds fragment
 flags by guess work, but a user tool can connect fragmented lines exactly
 by utilizing context information. So, current fragment flag is not appropriate
 after applying this patch, and we introduced new fragment flag 'f' instead of
 'c' and '+'.

To understand how to connect fragmented messages by changing the header of
/dev/kmsg, we assume that each two kernel threads executes the following
3 printk():

	pr_info("A1");
    	printk("A2");
    	printk("A3\n");

In current implementation, these threads can output as follows:

	6,3321,31629088,-;A1    <== Who output this message?
    	6,3322,31629091,c;A1         |
    	4,3323,31629094,+;A2    <----+
    	4,3324,31629095,+;A3         | Which?
    	4,3325,31629097,c;A2    <----+
    	4,3326,31629099,+;A3

A1, A2, and A3 messages of two threads are clearly fragmented in this result,
but we cannot understand who output the 1st line message and which messages were
output by whom. So, the relation of divided messages is unclear from this test.
Moreover, although the 4th fields of the header indicate fragment flags,
the flag in the 1st line shows not 'c' (fragment) but '-' (no fragment).

By applying this patch set, we can get a following result from /dev/kmsg:

	6,7868,2070756113,f,1185/-;A1
	6,7869,2070756116,f,1186/-;A1
	4,7870,2070756118,f,1186/-;A2
	4,7871,2070756119,-,1186/-;A3
	4,7872,2070756120,f,1185/-;A2
	4,7873,2070756122,-,1185/-;A3

1st line indicates fragmented line, PID=1185, and no interrupt context.
2nd line indicates fragmented line, PID=1186, and no interrupt context.
So, 1st line will connect to 6th line and 7th line by fragment flags and PID.
On the other hand, 2nd line will connect to 3rd line and 4th line.
A message merging tool can convert these messages as follows:

	6,7868,2070756113,-,1185/-;A1A2A3	/* thread1 */
	6,7869,2070756116,-,1186/-;A1A2A3	/* thread2 */

Thanks!

---

Yoshihiro YUNOMAE (2):
      printk: Add context information to the header of /dev/kmsg
      printk: Simplify fragmented line information of the header of /dev/kmsg


 Documentation/ABI/testing/dev-kmsg |   34 ++++++++----
 kernel/printk/printk.c             |  104 +++++++++++++++++++++++++-----------
 2 files changed, 95 insertions(+), 43 deletions(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
