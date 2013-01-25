Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3AYSlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:41:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27179 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab3AYSlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:41:44 -0500
Date: Fri, 25 Jan 2013 13:41:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/3] xen/ring: Add a new macro to detect
 whether there is an overflow in requests and response.
Message-ID: <20130125184135.GB1384@phenom.dumpdata.com>
References: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>
 <1359135152-30688-3-git-send-email-konrad.wilk@oracle.com>
 <5102C4B9.8050801@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <5102C4B9.8050801@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 06:45:29PM +0100, Roger Pau Monné wrote:
> On 25/01/13 18:32, Konrad Rzeszutek Wilk wrote:
> > We want to be able to exit if the difference between the request
> > produced (what the frontend tells us) and the requests consumed
> > (what we have so far processed) is greater than the ring size.
> > 
> > If so, we should terminate the loop as the request produced
> > is not trusted and it means it is bogus.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  include/xen/interface/io/ring.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/include/xen/interface/io/ring.h b/include/xen/interface/io/ring.h
> > index 75271b9..1114dde 100644
> > --- a/include/xen/interface/io/ring.h
> > +++ b/include/xen/interface/io/ring.h
> > @@ -188,6 +188,12 @@ struct __name##_back_ring {						\
> >  #define RING_REQUEST_CONS_OVERFLOW(_r, _cons)				\
> >      (((_cons) - (_r)->rsp_prod_pvt) >= RING_SIZE(_r))
> >  
> > +/* Loop termination condition: Is the difference between request produced
> > + * and request consumed greater than the ring size. If so, terminate the
> > + * loop. */
> > +#define RING_REQUEST_PROD_OVERFLOW(_r, _cons, _prod)                     \
> > +    (((_prod) - (_prod)) > RING_SIZE(_r))
> 
> Shouldn't the second _prod be _cons?
> 
> > +
> >  #define RING_PUSH_REQUESTS(_r) do {					\
> >      wmb(); /* back sees requests /before/ updated producer index */	\
> >      (_r)->sring->req_prod = (_r)->req_prod_pvt;				\
> > 
> 

Here is an update of it:

>From a84ea207716486515f083a6d708414dd3ad3aaf6 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 25 Jan 2013 12:29:51 -0500
Subject: [PATCH] ring/macro: Add a new macro to detect whether there is an
 overflow in requests and response.

We want to be able to exit if the difference between the request
produced (what the frontend tells us) and the requests consumed
(what we have so far processed) is greater than the ring size.

If so, we should terminate the loop as the request produced
is not trusted and it means it is bogus.

[v1:  Make the macro do the ring thing, swap arguments around to
match the comment]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 xen/include/public/io/ring.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/xen/include/public/io/ring.h b/xen/include/public/io/ring.h
index 38b7051..440ef9a 100644
--- a/xen/include/public/io/ring.h
+++ b/xen/include/public/io/ring.h
@@ -234,6 +234,12 @@ typedef struct __name##_back_ring __name##_back_ring_t
 #define RING_REQUEST_CONS_OVERFLOW(_r, _cons)                           \
     (((_cons) - (_r)->rsp_prod_pvt) >= RING_SIZE(_r))
 
+/* Loop termination condition: Is the difference between request produced
+ * and request consumed greater than the ring size. If so, terminate the
+ * loop. */
+#define RING_REQUEST_PROD_OVERFLOW(_r, _prod, _cons)                    \
+    (((_prod) - (_cons)) > RING_SIZE(_r))
+
 #define RING_PUSH_REQUESTS(_r) do {                                     \
     xen_wmb(); /* back sees requests /before/ updated producer index */ \
     (_r)->sring->req_prod = (_r)->req_prod_pvt;                         \
-- 
1.8.0.2

