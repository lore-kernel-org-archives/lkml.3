Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab3FSQpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:45:36 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:1574
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756707Ab3FSQpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:45:33 -0400
Message-ID: <51C1E028.2040700@caviumnetworks.com>
Date: Wed, 19 Jun 2013 09:45:28 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <ralf@linux-mips.org>, Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 3/5] tty/8250_dw: Add support for OCTEON UARTS.
References: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com> <1371582775-12141-4-git-send-email-ddaney.cavm@gmail.com> <2302882.NVjP8DdXWY@wuerfel>
In-Reply-To: <2302882.NVjP8DdXWY@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-Antispam-Report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:0;SRVR:SN2PR07MB064;H:BLUPRD0712HT001.namprd07.prod.outlook.com;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 03:01 AM, Arnd Bergmann wrote:
> On Tuesday 18 June 2013 12:12:53 David Daney wrote:
>> +static unsigned int dw8250_serial_inq(struct uart_port *p, int offset)
>> +{
>> +       offset <<= p->regshift;
>> +
>> +       return (u8)__raw_readq(p->membase + offset);
>> +}
>> +
>> +static void dw8250_serial_outq(struct uart_port *p, int offset, int value)
>> +{
>> +       struct dw8250_data *d = p->private_data;
>> +
>> +       if (offset == UART_LCR)
>> +               d->last_lcr = value;
>> +
>> +       offset <<= p->regshift;
>> +       __raw_writeq(value, p->membase + offset);
>> +       dw8250_serial_inq(p, UART_LCR);
>> +}
>
> This breaks building on 32 bit architectures as I found on my daily ARM
> builds: __raw_writeq cannot be defined on architectures that don't have
> native 64 bit data access instructions.

I will rework the patch to avoid this problem.


> It's also wrong to use the
> __raw_* variant, which is not guaranteed to be atomic and is not
> endian-safe.

We do runtime probing and only use this function on platforms where it 
is appropriate, so atomicity is not an issue.  As for endianess, I used 
the __raw_ variant precisely because it is correct for both big and 
little endian kernels.

David Daney


