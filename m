Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab3IPSJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:09:03 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:47325 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3IPSJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:09:01 -0400
Message-ID: <5237491E.8080901@gmail.com>
Date: Tue, 17 Sep 2013 03:08:30 +0900
From: ERAMOTO Masaya <eramoto.masaya@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Time: Clocksource: finish searching when clocksource_enqueue()
 found the inserting place.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

clocksource_enqueue() do extra behavior in the sorted list as below:
   * it compares all clocksources in the list even if found the
     inserting place.
   * it copies to entry until finding there.

So fixed clocksource_enqueue() as below:
   * it finishes to compare clocksource when found there.
   * it copies to entry only when found there.

Signed-off-by: ERAMOTO Masaya <eramoto.masaya@gmail.com>
---
  kernel/time/clocksource.c | 6 ++++--
  1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 50a8736..5b340a4 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -700,9 +700,11 @@ static void clocksource_enqueue(struct clocksource *cs)

  	list_for_each_entry(tmp, &clocksource_list, list)
  		/* Keep track of the place, where to insert */
-		if (tmp->rating >= cs->rating)
+		if (tmp->rating < cs->rating) {
  			entry = &tmp->list;
-	list_add(&cs->list, entry);
+			break;
+		}
+	list_add_tail(&cs->list, entry);
  }

  /**
