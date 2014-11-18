Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaKRWMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 17:12:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaKRWMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 17:12:21 -0500
Date: Tue, 18 Nov 2014 14:12:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Mahendran Ganesh <opensource.ganesh@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-mm@kvack.or,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zsmalloc: fix zs_init cpu notifier error handling
Message-Id: <20141118141212.07b64fdd2f32e8d3b0f725cb@linux-foundation.org>
In-Reply-To: <1415969826-6416-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1415969826-6416-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 21:57:06 +0900 Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> Mahendran Ganesh reported that zpool-enabled zsmalloc should not
> call zpool_unregister_driver() from zs_init() if cpu notifier
> registration has failed, because error handling is performed
> before we register the driver via zpool_register_driver() call.
> 
> Factor out cpu notifier registration and unregistration code and
> fix zs_init() error handling.


So we can now do this, yes?

--- a/mm/zsmalloc.c~mm-zsmallocc-use-__init-and-__exit
+++ a/mm/zsmalloc.c
@@ -911,7 +911,7 @@ static int zs_register_cpu_notifier(void
 	return notifier_to_errno(ret);
 }
 
-static void zs_exit(void)
+static void __exit zs_exit(void)
 {
 #ifdef CONFIG_ZPOOL
 	zpool_unregister_driver(&zs_zpool_driver);
@@ -919,7 +919,7 @@ static void zs_exit(void)
 	zs_unregister_cpu_notifier();
 }
 
-static int zs_init(void)
+static int __init zs_init(void)
 {
 	int ret = zs_register_cpu_notifier();
 

