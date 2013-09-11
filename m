Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3IKMcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:32:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3IKMcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:32:15 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=b9WLESoJ160A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=MQPZUH6EU9sA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=sqOu0AefKciJkJqnI-oA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 08:32:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [197/251] iwl4965: reset firmware after rfkill off
Message-ID: <20130911083212.1fe6d06e@gandalf.local.home>
In-Reply-To: <20130911074559.GA2368@redhat.com>
References: <20130911042707.738353451@goodmis.org>
	<20130911042924.950506810@goodmis.org>
	<20130911074559.GA2368@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 09:46:00 +0200
Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> On Wed, Sep 11, 2013 at 12:30:24AM -0400, Steven Rostedt wrote:
> > 3.6.11.9-rc1 stable review patch.
> > If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Stanislaw Gruszka <sgruszka@redhat.com>
> > 
> > [ Upstream commit 788f7a56fce1bcb2067b62b851a086fca48a0056 ]
> 
> This require follow up - upstream commit:
> 
> commit b2fcc0aee58a3435566dd6d8501a0b355552f28b
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Wed Aug 21 10:18:19 2013 +0200
> 
>     iwl4965: fix rfkill set state regression
> 
> which seems to be missed on the set.
> 

Thanks! I added this:

>From 7bde0f4f59e18d5fceadeb6447addfb65ac6c539 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 21 Aug 2013 10:18:19 +0200
Subject: [PATCH] iwl4965: fix rfkill set state regression

[ Upstream commit b2fcc0aee58a3435566dd6d8501a0b355552f28b ]

My current 3.11 fix:

commit 788f7a56fce1bcb2067b62b851a086fca48a0056
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Thu Aug 1 12:07:55 2013 +0200

    iwl4965: reset firmware after rfkill off

broke rfkill notification to user-space . I missed that bug, because
I compiled without CONFIG_RFKILL, sorry about that.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index f6624b8..167ddec 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4415,9 +4415,9 @@ il4965_irq_tasklet(struct il_priv *il)
 			set_bit(S_RFKILL, &il->status);
 		} else {
 			clear_bit(S_RFKILL, &il->status);
-			wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
 			il_force_reset(il, true);
 		}
+		wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}
-- 
1.7.10.4


-- Steve
