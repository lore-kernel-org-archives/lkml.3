Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbaFWTyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:54:16 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:20443 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbaFWTyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:54:15 -0400
X-IronPort-AV: E=Sophos;i="5.01,532,1400050800"; 
   d="scan'208";a="35613140"
From: Markus Mayer <markus.mayer@linaro.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>
CC: Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] direct-io: squelch maybe-uninitialized warning in do_direct_IO()
Date: Mon, 23 Jun 2014 12:54:08 -0700
Message-ID: <1403553248-16536-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403323139-12858-1-git-send-email-jason@lakedaemon.net>
References: <1403323139-12858-1-git-send-email-jason@lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did a bit of digging on this and I am wondering if the initialization
of "to" and "from" to 0 should instead be done in dio_get_page().

The warning is caused by the return in dio_get_page():

		ret = dio_refill_pages(dio, sdio);
		if (ret)
			return ERR_PTR(ret);

This code path would leave "to" and "from" uninitialized (even though the
caller currently never uses the variables in that case).

If both variables are initialized to 0 in dio_get_page(), it would
guarantee that any future callers of dio_get_page() also get to take
advantage of the initialization. If, however, the variables are only
initialized in do_direct_IO(), other callers would have to take care of
this themselves (or the same warnings will pop up there).

There aren't currently any other callers to dio_get_page(), so the
choice is probably not a terribly critical one right now, but I wanted
to at least point this out.

Regards,
-Markus
