Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbaE3B3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:29:42 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.224]:43931
	"EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbaE3B3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:29:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuoBAKXeh1OVhxBY/2dsb2JhbAANTK5DAQEBAQEBBpgYAYEegxkBAQEEJ1EBEAsNCwkWDwkDAgECAUUGDQEFAgEBuhCmExeFVYh9B4RAAQOhCo9e
X-IronPort-AV: E=Sophos;i="4.98,937,1392134400"; 
   d="scan'208";a="527914255"
Message-ID: <5387DF05.1020103@uclinux.org>
Date: Fri, 30 May 2014 11:29:41 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: rcu alignment warning tripping on m68k
References: <538696A0.5090601@uclinux.org> <20140529141151.21ed6f95@alan.etchedpixels.co.uk>
In-Reply-To: <20140529141151.21ed6f95@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/14 23:11, One Thousand Gnomes wrote:
> On Thu, 29 May 2014 12:08:32 +1000
> Greg Ungerer <gerg@uclinux.org> wrote:
> 
>> Hi All,
>>
>> Inside kernel/rcy/tree.c in __call_rcu() it does an alignment check on
>> the head pointer passed in. This trips on m68k systems, because they only
>> need alignment of 32bit quantities to 16bit boundaries.
> 
> __alignof perhaps ?

That might do. Change then becomes something like:

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2467,7 +2467,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_
        unsigned long flags;
        struct rcu_data *rdp;
 
-       WARN_ON_ONCE((unsigned long)head & 0x3); /* Misaligned rcu_head! */
+       WARN_ON_ONCE((unsigned long)head & (__alignof__(head) - 1)); /* Misaligned rcu_head! */
        if (debug_rcu_head_queue(head)) {
                /* Probable double call_rcu(), so leak the callback. */
                ACCESS_ONCE(head->func) = rcu_leak_callback;

Thanks
Greg


