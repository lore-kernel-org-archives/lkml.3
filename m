Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbaHGGSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:18:55 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:54850 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbaHGGSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:18:53 -0400
Message-ID: <53E31A47.9000407@mentor.com>
Date: Thu, 07 Aug 2014 11:48:47 +0530
From: Deepak <deepak_das@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: davem@davemloft.net, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [RFC] net: Replace del_timer() with del_timer_sync()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2014 06:18:51.0329 (UTC) FILETIME=[74EDCB10:01CFB207]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

     on SMP system, del_timer() might return even if the timer function
     is running on other cpu so sk_stop_timer() will execute __sock_put()
     while timer is accessing the socket on other cpu causing 
"use-after-free".

     This commit replaces del_timer() with del_timer_sync() in 
sk_stop_timer().
     del_timer_sync() will wait untill the timer function is not running in
     any other cpu hence making sk_stop_timer() SMP safe.

     Signed-off-by: Deepak Das <deepak_das@mentor.com>

diff --git a/net/core/sock.c b/net/core/sock.c
index 026e01f..491a84d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2304,7 +2304,7 @@ EXPORT_SYMBOL(sk_reset_timer);

  void sk_stop_timer(struct sock *sk, struct timer_list* timer)
  {
-       if (del_timer(timer))
+       if (del_timer_sync(timer))
                 __sock_put(sk);
  }
  EXPORT_SYMBOL(sk_stop_timer);
