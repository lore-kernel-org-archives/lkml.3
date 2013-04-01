Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3DACx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 22:53:29 -0400
Received: from intranet.asianux.com ([58.214.24.6]:10854 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab3DACx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 22:53:27 -0400
X-Spam-Score: -100.8
Message-ID: <5158F689.5040406@asianux.com>
Date: Mon, 01 Apr 2013 10:52:57 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: jhovold@gmail.com, Jiri Slaby <jslaby@suse.cz>, mferrell@uplogix.com
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] drivers/usb/serial: looping issue: return value may
 override by looping
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

in drivers/usb/serial/mos7840.c:

  in 'for' looping (line 632..657)
    the return value 'rv' may override if not have a check in time (line 654)

  next checking can not find failure which generated during looping (line 658)

  please help check, thanks.


gchen.

 579 static void mos7840_interrupt_callback(struct urb *urb)
 580 {
 581         int result;
 582         int length;
 583         struct moschip_port *mos7840_port;
 584         struct usb_serial *serial;
 585         __u16 Data;
 586         unsigned char *data;
 587         __u8 sp[5], st;
 588         int i, rv = 0;
 589         __u16 wval, wreg = 0;
 590         int status = urb->status;
 591 
 592         switch (status) {
 593         case 0:
 594                 /* success */
 595                 break;
 596         case -ECONNRESET:
 597         case -ENOENT:
 598         case -ESHUTDOWN:
 599                 /* this urb is terminated, clean up */
 600                 dev_dbg(&urb->dev->dev, "%s - urb shutting down with status: %d\n",
 601                         __func__, status);
 602                 return;
 603         default:
 604                 dev_dbg(&urb->dev->dev, "%s - nonzero urb status received: %d\n",
 605                         __func__, status);
 606                 goto exit;
 607         }
 608 
 609         length = urb->actual_length;
 610         data = urb->transfer_buffer;
 611 
 612         serial = urb->context;
 613 
 614         /* Moschip get 5 bytes
 615          * Byte 1 IIR Port 1 (port.number is 0)
 616          * Byte 2 IIR Port 2 (port.number is 1)
 617          * Byte 3 IIR Port 3 (port.number is 2)
 618          * Byte 4 IIR Port 4 (port.number is 3)
 619          * Byte 5 FIFO status for both */
 620 
 621         if (length && length > 5) {
 622                 dev_dbg(&urb->dev->dev, "%s", "Wrong data !!!\n");
 623                 return;
 624         }
 625 
 626         sp[0] = (__u8) data[0];
 627         sp[1] = (__u8) data[1];
 628         sp[2] = (__u8) data[2];
 629         sp[3] = (__u8) data[3];
 630         st = (__u8) data[4];
 631 
 632         for (i = 0; i < serial->num_ports; i++) {
 633                 mos7840_port = mos7840_get_port_private(serial->port[i]);
 634                 wval =
 635                     (((__u16) serial->port[i]->number -
 636                       (__u16) (serial->minor)) + 1) << 8;
 637                 if (mos7840_port->open) {
 638                         if (sp[i] & 0x01) {
 639                                 dev_dbg(&urb->dev->dev, "SP%d No Interrupt !!!\n", i);
 640                         } else {
 641                                 switch (sp[i] & 0x0f) {
 642                                 case SERIAL_IIR_RLS:
 643                                         dev_dbg(&urb->dev->dev, "Serial Port %d: Receiver status error or \n", i);
 644                                         dev_dbg(&urb->dev->dev, "address bit detected in 9-bit mode\n");
 645                                         mos7840_port->MsrLsr = 1;
 646                                         wreg = LINE_STATUS_REGISTER;
 647                                         break;
 648                                 case SERIAL_IIR_MS:
 649                                         dev_dbg(&urb->dev->dev, "Serial Port %d: Modem status change\n", i);
 650                                         mos7840_port->MsrLsr = 0;
 651                                         wreg = MODEM_STATUS_REGISTER;
 652                                         break;
 653                                 }
 654                                 rv = mos7840_get_reg(mos7840_port, wval, wreg, &Data);
 655                         }
 656                 }
 657         }
 658         if (!(rv < 0))
 659                 /* the completion handler for the control urb will resubmit */
 660                 return;
 661 exit:
 662         result = usb_submit_urb(urb, GFP_ATOMIC);
 663         if (result) {
 664                 dev_err(&urb->dev->dev,
 665                         "%s - Error %d submitting interrupt urb\n",
 666                         __func__, result);
 667         }
 668 }

