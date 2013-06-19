Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526Ab3FSKAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:00:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873Ab3FSKAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:00:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 3/5] tty/8250_dw: Add support for OCTEON UARTS.
Date: Wed, 19 Jun 2013 12:01:06 +0200
Message-ID: <2302882.NVjP8DdXWY@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.4; x86_64; ; )
In-Reply-To: <1371582775-12141-4-git-send-email-ddaney.cavm@gmail.com>
References: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com> <1371582775-12141-4-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mzmZ9+bBWurp4/xnwCM5dwHtFCAcxYpyIoJpQwkoytV
 0VXYdcNHpridv+kXgnFk9f00byrFBKJQGQv5iJrXUWBxNyrg1K
 sy0CQMAFpPsiXF/+QHCiMWRpsVys6sGl7eyXfqVe3TWcRXnExp
 thBu9Z/Vpx8Gb33m3ZAAd/Y8f0IXo3fjneWUAUDM0FcGuL4CXg
 HvZ2KxnimvU9BQiMwDo6fy8n98NBlrKmV3SbJYeKpoNlc02+Xe
 vYArhr0lhLJHH9ww+65tBOBETojTaOSshpjIywZE0h4opxFJP8
 aAiPRSOD3jiysE75iAJ8mcl1Wit4kPvctBRpJ8U4H8AqPJ6rKo
 HcVFLZ0qFQ0wfakU8Fa4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 June 2013 12:12:53 David Daney wrote:
> +static unsigned int dw8250_serial_inq(struct uart_port *p, int offset)
> +{
> +       offset <<= p->regshift;
> +
> +       return (u8)__raw_readq(p->membase + offset);
> +}
> +
> +static void dw8250_serial_outq(struct uart_port *p, int offset, int value)
> +{
> +       struct dw8250_data *d = p->private_data;
> +
> +       if (offset == UART_LCR)
> +               d->last_lcr = value;
> +
> +       offset <<= p->regshift;
> +       __raw_writeq(value, p->membase + offset);
> +       dw8250_serial_inq(p, UART_LCR);
> +}

This breaks building on 32 bit architectures as I found on my daily ARM
builds: __raw_writeq cannot be defined on architectures that don't have
native 64 bit data access instructions. It's also wrong to use the
__raw_* variant, which is not guaranteed to be atomic and is not
endian-safe.

	Arnd
