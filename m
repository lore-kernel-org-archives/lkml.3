Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaDVTPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:15:09 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:40022 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaDVTPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:15:05 -0400
Message-ID: <5356BFB1.6070901@gmail.com>
Date: Tue, 22 Apr 2014 16:14:57 -0300
From: Nicolas Del Piano <ndel314@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] octeon-usb/octeon-hcd.c
Content-Type: multipart/mixed;
 boundary="------------090505030400060701060903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090505030400060701060903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------090505030400060701060903
Content-Type: text/plain; charset=UTF-8;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch"

Subject: [PATCH] coding style errors fix
From: Nicolas Del Piano <ndel314@gmail.com>

Fixed all the coding style errors.
There are some warnings that may be fixed.
Signed-off-by: Nicolas Del Piano <ndel314@gmail.com>
---
--- linux-next/drivers/staging/octeon-usb/octeon-hcd.c.orig	2014-04-19 02:31:31.626040005 -0300
+++ linux-next/drivers/staging/octeon-usb/octeon-hcd.c	2014-04-19 02:18:49.282259735 -0300
@@ -159,13 +159,13 @@ enum cvmx_usb_complete {
  *			status call.
  */
 struct cvmx_usb_port_status {
-	uint32_t reserved		: 25;
-	uint32_t port_enabled		: 1;
-	uint32_t port_over_current	: 1;
-	uint32_t port_powered		: 1;
-	enum cvmx_usb_speed port_speed	: 2;
-	uint32_t connected		: 1;
-	uint32_t connect_change		: 1;
+	uint32_t reserved:25;
+	uint32_t port_enabled:1;
+	uint32_t port_over_current:1;
+	uint32_t port_powered:1;
+	enum cvmx_usb_speed port_speed:2;
+	uint32_t connected:1;
+	uint32_t connect_change:1;
 };
 
 /**
@@ -181,11 +181,11 @@ struct cvmx_usb_port_status {
 union cvmx_usb_control_header {
 	uint64_t u64;
 	struct {
-		uint64_t request_type   : 8;
-		uint64_t request        : 8;
-		uint64_t value          : 16;
-		uint64_t index          : 16;
-		uint64_t length         : 16;
+		uint64_t request_type:8;
+		uint64_t request:8;
+		uint64_t value:16;
+		uint64_t index:16;
+		uint64_t length:16;
 	} s;
 };
 
@@ -246,7 +246,7 @@ enum cvmx_usb_pipe_flags {
 };
 
 /* Normal prefetch that use the pref instruction. */
-#define CVMX_PREFETCH(address, offset) asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0))
+#define (CVMX_PREFETCH(address, offset) asm volatile ("pref %[type], %[off](%[rbase])" : : ([rbase] "d" (address), [off] "I" (offset), [type] "n" (0))))
 
 /* Maximum number of times to retry failed transactions */
 #define MAX_RETRIES		3
@@ -437,7 +437,7 @@ struct octeon_hcd {
 		type c;							    \
 		while (1) {						    \
 			c.u32 = __cvmx_usb_read_csr32(usb, address);	    \
-			if (c.s.field op (value)) {			    \
+			if (c.s.field op(value)) {			    \
 				result = 0;				    \
 				break;					    \
 			} else if (cvmx_get_cycle() > done) {		    \
@@ -465,112 +465,6 @@ struct octeon_hcd {
 #define USB_FIFO_ADDRESS(channel, usb_index) (CVMX_USBCX_GOTGCTL(usb_index) + ((channel)+1)*0x1000)
 
 /**
- * struct octeon_temp_buffer - a bounce buffer for USB transfers
- * @temp_buffer: the newly allocated temporary buffer (including meta-data)
- * @orig_buffer: the original buffer passed by the USB stack
- * @data:	 the newly allocated temporary buffer (excluding meta-data)
- *
- * Both the DMA engine and FIFO mode will always transfer full 32-bit words. If
- * the buffer is too short, we need to allocate a temporary one, and this struct
- * represents it.
- */
-struct octeon_temp_buffer {
-	void *temp_buffer;
-	void *orig_buffer;
-	u8 data[0];
-};
-
-/**
- * octeon_alloc_temp_buffer - allocate a temporary buffer for USB transfer
- *                            (if needed)
- * @urb:	URB.
- * @mem_flags:	Memory allocation flags.
- *
- * This function allocates a temporary bounce buffer whenever it's needed
- * due to HW limitations.
- */
-static int octeon_alloc_temp_buffer(struct urb *urb, gfp_t mem_flags)
-{
-	struct octeon_temp_buffer *temp;
-
-	if (urb->num_sgs || urb->sg ||
-	    (urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP) ||
-	    !(urb->transfer_buffer_length % sizeof(u32)))
-		return 0;
-
-	temp = kmalloc(ALIGN(urb->transfer_buffer_length, sizeof(u32)) +
-		       sizeof(*temp), mem_flags);
-	if (!temp)
-		return -ENOMEM;
-
-	temp->temp_buffer = temp;
-	temp->orig_buffer = urb->transfer_buffer;
-	if (usb_urb_dir_out(urb))
-		memcpy(temp->data, urb->transfer_buffer,
-		       urb->transfer_buffer_length);
-	urb->transfer_buffer = temp->data;
-	urb->transfer_flags |= URB_ALIGNED_TEMP_BUFFER;
-
-	return 0;
-}
-
-/**
- * octeon_free_temp_buffer - free a temporary buffer used by USB transfers.
- * @urb: URB.
- *
- * Frees a buffer allocated by octeon_alloc_temp_buffer().
- */
-static void octeon_free_temp_buffer(struct urb *urb)
-{
-	struct octeon_temp_buffer *temp;
-
-	if (!(urb->transfer_flags & URB_ALIGNED_TEMP_BUFFER))
-		return;
-
-	temp = container_of(urb->transfer_buffer, struct octeon_temp_buffer,
-			    data);
-	if (usb_urb_dir_in(urb))
-		memcpy(temp->orig_buffer, urb->transfer_buffer,
-		       urb->actual_length);
-	urb->transfer_buffer = temp->orig_buffer;
-	urb->transfer_flags &= ~URB_ALIGNED_TEMP_BUFFER;
-	kfree(temp->temp_buffer);
-}
-
-/**
- * octeon_map_urb_for_dma - Octeon-specific map_urb_for_dma().
- * @hcd:	USB HCD structure.
- * @urb:	URB.
- * @mem_flags:	Memory allocation flags.
- */
-static int octeon_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
-				  gfp_t mem_flags)
-{
-	int ret;
-
-	ret = octeon_alloc_temp_buffer(urb, mem_flags);
-	if (ret)
-		return ret;
-
-	ret = usb_hcd_map_urb_for_dma(hcd, urb, mem_flags);
-	if (ret)
-		octeon_free_temp_buffer(urb);
-
-	return ret;
-}
-
-/**
- * octeon_unmap_urb_for_dma - Octeon-specific unmap_urb_for_dma()
- * @hcd:	USB HCD structure.
- * @urb:	URB.
- */
-static void octeon_unmap_urb_for_dma(struct usb_hcd *hcd, struct urb *urb)
-{
-	usb_hcd_unmap_urb_for_dma(hcd, urb);
-	octeon_free_temp_buffer(urb);
-}
-
-/**
  * Read a USB 32bit CSR. It performs the necessary address swizzle
  * for 32bit CSRs and logs the value in a readable format if
  * debugging is on.
@@ -1286,7 +1180,8 @@ static struct cvmx_usb_pipe *cvmx_usb_op
 	if (__cvmx_usb_pipe_needs_split(usb, pipe)) {
 		pipe->interval = interval*8;
 		/* Force start splits to be schedule on uFrame 0 */
-		pipe->next_tx_frame = ((usb->frame_number+7)&~7) + pipe->interval;
+		pipe->next_tx_frame =
+			((usb->frame_number+7)&~7) + pipe->interval;
 	} else {
 		pipe->interval = interval;
 		pipe->next_tx_frame = usb->frame_number + pipe->interval;
@@ -1542,19 +1437,26 @@ static void __cvmx_usb_start_channel_con
 		usbc_hctsiz.s.pid = 3; /* Setup */
 		bytes_to_transfer = sizeof(*header);
 		/* All Control operations start with a setup going OUT */
-		USB_SET_FIELD32(CVMX_USBCX_HCCHARX(channel, usb->index), union cvmx_usbcx_hccharx, epdir, CVMX_USB_DIRECTION_OUT);
+		USB_SET_FIELD32(CVMX_USBCX_HCCHARX(channel, usb->index),
+			union cvmx_usbcx_hccharx, epdir,
+				CVMX_USB_DIRECTION_OUT);
 		/*
 		 * Setup send the control header instead of the buffer data. The
 		 * buffer data will be used in the next stage
 		 */
-		__cvmx_usb_write_csr64(usb, CVMX_USBNX_DMA0_OUTB_CHN0(usb->index) + channel*8, transaction->control_header);
+		__cvmx_usb_write_csr64(usb,
+			CVMX_USBNX_DMA0_OUTB_CHN0(usb->index) + channel*8,
+				transaction->control_header);
 		break;
 	case CVMX_USB_STAGE_SETUP_SPLIT_COMPLETE:
 		usbc_hctsiz.s.pid = 3; /* Setup */
 		bytes_to_transfer = 0;
 		/* All Control operations start with a setup going OUT */
-		USB_SET_FIELD32(CVMX_USBCX_HCCHARX(channel, usb->index), union cvmx_usbcx_hccharx, epdir, CVMX_USB_DIRECTION_OUT);
-		USB_SET_FIELD32(CVMX_USBCX_HCSPLTX(channel, usb->index), union cvmx_usbcx_hcspltx, compsplt, 1);
+		USB_SET_FIELD32(CVMX_USBCX_HCCHARX(channel, usb->index),
+			union cvmx_usbcx_hccharx, epdir,
+				CVMX_USB_DIRECTION_OUT);
+		USB_SET_FIELD32(CVMX_USBCX_HCSPLTX(channel, usb->index),
+			union cvmx_usbcx_hcspltx, compsplt, 1);
 		break;
 	case CVMX_USB_STAGE_DATA:
 		usbc_hctsiz.s.pid = __cvmx_usb_get_data_pid(pipe);
@@ -1711,21 +1613,32 @@ static void __cvmx_usb_start_channel(str
 			usbc_hcintmsk.s.stallmsk = 1;
 			usbc_hcintmsk.s.xfercomplmsk = 1;
 		}
-		__cvmx_usb_write_csr32(usb, CVMX_USBCX_HCINTMSKX(channel, usb->index), usbc_hcintmsk.u32);
+		__cvmx_usb_write_csr32(usb,
+			CVMX_USBCX_HCINTMSKX(channel, usb->index),
+				usbc_hcintmsk.u32);
 
 		/* Enable the channel interrupt to propagate */
-		usbc_haintmsk.u32 = __cvmx_usb_read_csr32(usb, CVMX_USBCX_HAINTMSK(usb->index));
+		usbc_haintmsk.u32 = __cvmx_usb_read_csr32(usb,
+					CVMX_USBCX_HAINTMSK(usb->index));
 		usbc_haintmsk.s.haintmsk |= 1<<channel;
-		__cvmx_usb_write_csr32(usb, CVMX_USBCX_HAINTMSK(usb->index), usbc_haintmsk.u32);
+		__cvmx_usb_write_csr32(usb,
+			CVMX_USBCX_HAINTMSK(usb->index), usbc_haintmsk.u32);
 	}
 
 	/* Setup the locations the DMA engines use  */
 	{
-		uint64_t dma_address = transaction->buffer + transaction->actual_bytes;
+		uint64_t dma_address = transaction->buffer
+					+ transaction->actual_bytes;
 		if (transaction->type == CVMX_USB_TRANSFER_ISOCHRONOUS)
-			dma_address = transaction->buffer + transaction->iso_packets[0].offset + transaction->actual_bytes;
-		__cvmx_usb_write_csr64(usb, CVMX_USBNX_DMA0_OUTB_CHN0(usb->index) + channel*8, dma_address);
-		__cvmx_usb_write_csr64(usb, CVMX_USBNX_DMA0_INB_CHN0(usb->index) + channel*8, dma_address);
+			dma_address = transaction->buffer
+					+ transaction->iso_packets[0].offset
+						+ transaction->actual_bytes;
+		__cvmx_usb_write_csr64(usb,
+			CVMX_USBNX_DMA0_OUTB_CHN0(usb->index)
+				+ channel*8, dma_address);
+		__cvmx_usb_write_csr64(usb,
+			CVMX_USBNX_DMA0_INB_CHN0(usb->index)
+				+ channel*8, dma_address);
 	}
 
 	/* Setup both the size of the transfer and the SPLIT characteristics */
@@ -2036,8 +1949,12 @@ static void __cvmx_usb_schedule(struct c
 		 * Without DMA we need to be careful to not schedule something
 		 * at the end of a frame and cause an overrun.
 		 */
-		union cvmx_usbcx_hfnum hfnum = {.u32 = __cvmx_usb_read_csr32(usb, CVMX_USBCX_HFNUM(usb->index))};
-		union cvmx_usbcx_hfir hfir = {.u32 = __cvmx_usb_read_csr32(usb, CVMX_USBCX_HFIR(usb->index))};
+		union cvmx_usbcx_hfnum hfnum = {.u32 =
+			__cvmx_usb_read_csr32(usb,
+				CVMX_USBCX_HFNUM(usb->index))};
+		union cvmx_usbcx_hfir hfir = {.u32 =
+			__cvmx_usb_read_csr32(usb,
+				CVMX_USBCX_HFIR(usb->index))};
 		if (hfnum.s.frrem < hfir.s.frint/4)
 			goto done;
 	}
@@ -3483,7 +3400,7 @@ static int octeon_usb_hub_status_data(st
 	buf[0] = 0;
 	buf[0] = port_status.connect_change << 1;
 
-	return (buf[0] != 0);
+	return buf[0] != 0;
 }
 
 static int octeon_usb_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex, char *buf, u16 wLength)
@@ -3707,8 +3624,6 @@ static const struct hc_driver octeon_hc_
 	.get_frame_number	= octeon_usb_get_frame_number,
 	.hub_status_data	= octeon_usb_hub_status_data,
 	.hub_control		= octeon_usb_hub_control,
-	.map_urb_for_dma	= octeon_map_urb_for_dma,
-	.unmap_urb_for_dma	= octeon_unmap_urb_for_dma,
 };
 
 static int octeon_usb_probe(struct platform_device *pdev)

--------------090505030400060701060903--
