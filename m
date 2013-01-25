Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab3AYSlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:41:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40651 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab3AYSlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:41:21 -0500
Date: Fri, 25 Jan 2013 13:41:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] xen/ring: Add a new macro to detect whether there is
 an overflow in requests and response.
Message-ID: <20130125184112.GA1384@phenom.dumpdata.com>
References: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>
 <1359135152-30688-3-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359135152-30688-3-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 12:32:31PM -0500, Konrad Rzeszutek Wilk wrote:
> We want to be able to exit if the difference between the request
> produced (what the frontend tells us) and the requests consumed
> (what we have so far processed) is greater than the ring size.
> 
> If so, we should terminate the loop as the request produced
> is not trusted and it means it is bogus.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  include/xen/interface/io/ring.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/xen/interface/io/ring.h b/include/xen/interface/io/ring.h
> index 75271b9..1114dde 100644
> --- a/include/xen/interface/io/ring.h
> +++ b/include/xen/interface/io/ring.h
> @@ -188,6 +188,12 @@ struct __name##_back_ring {						\
>  #define RING_REQUEST_CONS_OVERFLOW(_r, _cons)				\
>      (((_cons) - (_r)->rsp_prod_pvt) >= RING_SIZE(_r))
>  
> +/* Loop termination condition: Is the difference between request produced
> + * and request consumed greater than the ring size. If so, terminate the
> + * loop. */
> +#define RING_REQUEST_PROD_OVERFLOW(_r, _cons, _prod)                     \
> +    (((_prod) - (_prod)) > RING_SIZE(_r))
> +
>  #define RING_PUSH_REQUESTS(_r) do {					\
>      wmb(); /* back sees requests /before/ updated producer index */	\
>      (_r)->sring->req_prod = (_r)->req_prod_pvt;				\
> -- 
> 1.8.0.2
>

Per Roger sharp eyes:
 
>From 567782db60a5e410924751fb7c2e021095720b93 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 23 Jan 2013 16:53:54 -0500
Subject: [PATCH 1/2] xen/ring: Add a new macro to detect whether there is an
 overflow in requests and response.

We want to be able to exit if the difference between the request
produced (what the frontend tells us) and the requests consumed
(what we have so far processed) is greater than the ring size.

If so, we should terminate the loop as the request produced
is not trusted and it means it is bogus.

Cc: stable@vger.kernel.org
[v1: Make the macro do the ring thing, swap arguments around to
match the comment]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/xen/interface/io/ring.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/xen/interface/io/ring.h b/include/xen/interface/io/ring.h
index 75271b9..94aa885 100644
--- a/include/xen/interface/io/ring.h
+++ b/include/xen/interface/io/ring.h
@@ -188,6 +188,12 @@ struct __name##_back_ring {						\
 #define RING_REQUEST_CONS_OVERFLOW(_r, _cons)				\
     (((_cons) - (_r)->rsp_prod_pvt) >= RING_SIZE(_r))
 
+/* Loop termination condition: Is the difference between request produced
+ * and request consumed greater than the ring size. If so, terminate the
+ * loop. */
+#define RING_REQUEST_PROD_OVERFLOW(_r, _prod, _cons)                    \
+    (((_prod) - (_cons)) > RING_SIZE(_r))
+
 #define RING_PUSH_REQUESTS(_r) do {					\
     wmb(); /* back sees requests /before/ updated producer index */	\
     (_r)->sring->req_prod = (_r)->req_prod_pvt;				\
-- 
1.8.0.2

