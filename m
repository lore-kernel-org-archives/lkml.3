Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083AbaLLDa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 22:30:59 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:11199 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383AbaLLDa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 22:30:58 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>
Date: Fri, 12 Dec 2014 11:30:53 +0800
Subject: [RFC] discard task stack pages instead of pageout into swap
 partition
Thread-Topic: [RFC] discard task stack pages instead of pageout into swap
 partition
Thread-Index: AdAUm5skPt4e77aMQROTaYv2A3+JEABH+XSw
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B31408@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
	<CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
	<35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net>
	<20141205143134.37139da2208c654a0d3cd942@linux-foundation.org>
	<35FD53F367049845BC99AC72306C23D103E688B313F4@CNBJMBX05.corpusers.net>
	<20141208114601.GA28846@node.dhcp.inet.fi>
	<35FD53F367049845BC99AC72306C23D103E688B313FB@CNBJMBX05.corpusers.net>
 <CALYGNiMEytHuND37f+hNdMKqCPzN0k_uha6CaeL_fyzrj-obNQ@mail.gmail.com>
In-Reply-To: <CALYGNiMEytHuND37f+hNdMKqCPzN0k_uha6CaeL_fyzrj-obNQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBC3VMJo015590

Hi,

I am think of discard stack pages if the old
Page is under the stack pointer(Assume stack grow down)
of the task, This page don't need pageout, we can free it directly,
When the task need it again, we just use a zero page to
Map, it is safe for stack .

But I don't know how to implement it,
And is there some issue if do like this ?

The following is pseudo code to explain my ideas.
Any comments are appreciated !
Thanks
---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index dcb4707..52e8314 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -962,6 +962,12 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 			; /* try to reclaim the page below */
 		}
 
+		if (page_vm_flags(page) & (VM_GROWSUP | VM_GROWSDOWN) &&
+				PageAnon(page) && !PageSwapCache(page)) {
+			if (page_task_is_sleep(page) && task_sp > page->index) {
+				zap_page_range(vma, page->index, PAGE_SIZE);
+			}
+		}
 		/*
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
