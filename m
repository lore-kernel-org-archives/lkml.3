Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3LNVEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 16:04:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60654 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab3LNVEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 16:04:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
Date: Sat, 14 Dec 2013 22:03:45 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com> <1386901645-28895-1-git-send-email-ynvich@gmail.com>
In-Reply-To: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312142203.45740.arnd@arndb.de>
X-Provags-ID: V02:K0:c8F4pvTlbejaR1SxTpiATrWyhKghlE3qHGccd+Oh+W0
 I+zYQXleSDbd8hT7AI1inoyCAcsgevH5PKD0IcW6hPrJESiPq7
 U0V3V1UUlJRBpgvn+YWfcEmRMDeNxQya6Fw/2uMUwJdYXiFURT
 XktYHYqspEnu0Jjw7ANVnVDlqAifTuAkR/C6mBxy07Q2ZFVFuJ
 bPye8HVSG5jyOYLlJNmONIHeDDTs0mQc8rsEkY21zHGjn7Zgjc
 nd5jZWcjRZDOdibPL6pHixqMQDev1tqVUKEp8QOBecHtlIJr4T
 LIqFAAlIO7OMGwTr/EATV9/8NoS1NVvhiorHW+f/SiPmsin6u1
 3RMH8C54MIJZPqclsFq4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 December 2013, Sergei Ianovich wrote:
> Fixed most review requirements. Details in respective patches.
> 
> I've completely met the requirement for using dmaengine-based DMA
> in patch v2-03/16. Tests showed new DMA was underperforming. It added
> on top of a pre-existing problem with MMC bus width and made the system
> barely usable. However, the new code in this patch work correctly with
> both the existing and the new DMA. Even if the new DMA is compiled into
> the kernel, the exisitng DMA initializes first.

As mentioned, I think this is a good approach, as long as it's coordinated
with Daniel's patches for the dmaengine. I would expect that once we
get to the bottom of this, there will only be a small overhead from
not directly using the dma registers but going through the dmaengine
API.

> I've also decided not to create a single mfd device for
> machine-specific devices. Instead each type is supported by a separate
> driver in respective subsystem. It was tempting to hardcode all the
> constants in one source file, but that requires ugly initialization.
> The taken way produces much cleaner code.

I think you should at least change the DT representation for the FPGA
to show one device as the actual FPGA and attach children to that,
multiple indirection levels if necessary.

I suspect that the fpga is on some external-bus port with a specific
chip-select, so I would model this as

	extbus {
		compatible = "simple-bus";
		#address-cells = <1>;
		#size-cells = <1>;
		/* bus addresses 0-0xfffff mapped to 0x17000000 */
		ranges = <0 0x17000000 0x100000>;
		interrupt-parent = <&fpga-irq>;

		fpga-irq: irq@6 {
			regs = <6 16>; /* translated addresses
			...
		};

		fgpa-bus {
			#address-cells = <1>;
			#size-cells = <1>;
			ranges;

			serial@9050 {
				...
			};
		};
	};

I also think you don't need to make the devices quite as fine-grained
here but instead group things together more. I would probably indeed
put everything that is not on one of the slots into a common device,
including the irqchip.

	Arnd
