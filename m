Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbbAVRqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:46:39 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:58307 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbbAVRqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:46:37 -0500
Message-ID: <54C1377B.9070801@hurleysoftware.com>
Date: Thu, 22 Jan 2015 12:46:35 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Schultz <jschultz@xes-inc.com>,
        Aaron Sierra <asierra@xes-inc.com>
Subject: Re: [PATCH 5/7] serial: 8250: Refactor XR17V35X divisor calculation
References: <1421947471-6396-1-git-send-email-peter@hurleysoftware.com> <1421947471-6396-6-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1421947471-6396-6-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 12:24 PM, Peter Hurley wrote:
> Exar XR17V35X PCIe uarts support a 4-bit fractional divisor register.
> Refactor the divisor calculation from the divisor programming.
> 
> Allow a fractional result from serial8250_get_divisor() and pass this
> result to serial8250_dl_write().
> 
> Simplify the calculation for quot and quot_frac. This was verified
> to be identical to the results of the original calculation with a test
> jig.
> 
> NB: The results were also compared with the divisor value chart
> on pg 33 of the Exar XR17V352 datasheet, rev 1.0.3, here:
> http://www.exar.com/common/content/document.ashx?id=1585
> which differs from the calculated values by 1 in the fractional result.
> This is because the calculated values are still rounded in the
> fractional result, whereas the table values are truncated. Note
> that the data error rate % values in the datasheet are for
> rounded fractional results, as the truncated fractional results
> have more error.
> 
> Cc: Joe Schultz <jschultz@xes-inc.com>
> Cc: Aaron Sierra <asierra@xes-inc.com>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

FWIW, here's the test jig:

--- /dev/null	2015-01-22 11:30:11.407707482 -0500
+++ divisor.c	2015-01-22 12:42:34.722403359 -0500
@@ -0,0 +1,92 @@
+/*
+ * divisor.c - test jig for evaluating computation equivalence
+ *	       of divisors for XR17V35x UART
+ */
+
+#include <stdio.h>
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof(x[0]))
+
+/* from include/linux/kernel.h */
+
+#define DIV_ROUND_CLOSEST(x, divisor)(			\
+{							\
+	typeof(x) __x = x;				\
+	typeof(divisor) __d = divisor;			\
+	(((typeof(x))-1) > 0 ||				\
+	 ((typeof(divisor))-1) > 0 || (__x) > 0) ?	\
+		(((__x) + ((__d) / 2)) / (__d)) :	\
+		(((__x) - ((__d) / 2)) / (__d));	\
+}							\
+)
+
+/* 125MHz clock on XR17V35x */
+unsigned int clk = 125000000;
+
+
+void calc_quot(unsigned int baud, unsigned int *quot, unsigned int *frac) {
+
+	unsigned int baud_x32 = (2 * clk) / baud;
+
+	*quot = baud_x32 / 32;
+	*frac = DIV_ROUND_CLOSEST(baud_x32 % 32, 2);
+}
+
+void calc_quot2(unsigned int baud, unsigned int *quot, unsigned int *frac) {
+
+	/* compute quotient as a 16.4 fixed point value */
+	unsigned int quot_16 = DIV_ROUND_CLOSEST(clk, baud);
+
+	*quot = quot_16 >> 4;
+	*frac = quot_16 & 0x0f;
+}
+
+
+int main() {
+	int i;
+	unsigned int bauds[] = {   2400,
+				   4800,
+				   9600,
+				  10000,
+				  19200,
+				  25000,
+				  28800,
+				  38400,
+				  50000,
+				  57600,
+				  75000,
+				 100000,
+				 115200,
+				 153600,
+				 200000,
+				 225000,
+				 230400,
+				 250000,
+				 300000,
+				 400000,
+				 460800,
+				 500000,
+				 576000,
+				 750000,
+				 921600,
+				1000000,
+				1152000,
+			       };
+
+	for (i = 0; i < ARRAY_SIZE(bauds); i++) {
+		unsigned int quot, frac;
+		unsigned int quot2, frac2;
+
+		calc_quot(bauds[i], &quot, &frac);
+		calc_quot2(bauds[i], &quot2, &frac2);
+
+		if (quot != quot2 || frac != frac2) {
+			printf("diff: %04x.%01x != %04x.%01x\n", quot, frac,
+			       quot2, frac2);
+		} else
+			printf("%10d  %02X %02X %01X\n", bauds[i],
+			       quot2 >> 8, quot2 & 0xff, frac2);
+	}
+
+	return 0;
+}

