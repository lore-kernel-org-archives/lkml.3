Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbaISMEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:04:52 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:33780 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbaISMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:04:51 -0400
From: Roman Gushchin <klamm@yandex-team.ru>
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <87d2bdcask.wl%klamm@yandex-team.ru>
References: <87d2bdcask.wl%klamm@yandex-team.ru>
Subject: Re: [PATCH] net_dma: fix memory leak in dma_pin_iocvec_pages
MIME-Version: 1.0
Message-Id: <15011411128281@webcorp02h.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 19 Sep 2014 16:04:41 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

03.09.2014, 13:38, "Roman Gushchin" <klamm@yandex-team.ru>:
> šdma_pin_iovec_pages() calls get_user_pages() for each iovec. If
> šget_user_pages() returns a number smaller than the requested number,
> šdma_pin_iovec_pages() calls dma_unpin_iovec_pages(). It releases
> špreviously allocated iovecs, but pages pinned by last get_user_pages()
> šcall remain unreleased.
> šFix this by calling put_page() for each such page.
>
> šSigned-off-by: Roman Gushchin <klamm@yandex-team.ru>
> š---
> ššdrivers/dma/iovlock.c | 5 ++++-
> šš1 file changed, 4 insertions(+), 1 deletion(-)
>
> šdiff --git a/drivers/dma/iovlock.c b/drivers/dma/iovlock.c
> šindex bb48a57..c393cf9 100644
> š--- a/drivers/dma/iovlock.c
> š+++ b/drivers/dma/iovlock.c
> š@@ -107,8 +107,11 @@ struct dma_pinned_list *dma_pin_iovec_pages(struct iovec *iov, size_t len)
> ššššššššššššššššššššššššššNULL);
> ššššššššššššššššššup_read(&current->mm->mmap_sem);
>
> š- if (ret != page_list->nr_pages)
> š+ if (ret != page_list->nr_pages) {
> š+ for (i = 0; i < ret; i++)
> š+ put_page(page_list->pages[i]);
> ššššššššššššššššššššššššššgoto unpin;
> š+ }
>
> ššššššššššššššššššlocal_list->nr_iovecs = i + 1;
> šššššššššš}
> š--
> š1.9.3
>
> š--
> šTo unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> šthe body of a message to majordomo@vger.kernel.org
> šMore majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> šPlease read the FAQ at šhttp://www.tux.org/lkml/
