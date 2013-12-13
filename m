Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab3LMRjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:39:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:57288 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752318Ab3LMRjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:39:05 -0500
Date: Fri, 13 Dec 2013 12:39:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Howells <dhowells@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wolfram@the-dreams.de>
Subject: Re: [PATCH] i2c: Add message transfer tracepoints for I2C and SMBUS
Message-ID: <20131213123902.06fe9c85@gandalf.local.home>
In-Reply-To: <22364.1386954254@warthog.procyon.org.uk>
References: <20131213104806.4fb56012@gandalf.local.home>
	<20131213142627.4014.42860.stgit@warthog.procyon.org.uk>
	<20131213163349.4bc686c0@endymion.delvare>
	<22364.1386954254@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013 17:04:14 +0000
David Howells <dhowells@redhat.com> wrote:

> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > Would it be possible to print this as a string rather than a number?
> > > The protocol numbers are completely arbitrary, so the reader would have
> > > to open i2c.h each time to figure out what is what.
> > 
> > That can be done in the TP_printk() with:
> > 
> > 	".. %s ..", ..,
> > 	__print_symbolic(__entry->protocol,
> > 		{ I2C_SMBUS_QUICK	,	"QUICK"	},
> > 		{ I2C_SMBUS_BYTE	,	"BYTE"	},
> > 		{ I2C_SMBUS_BYTE_DATA	,	"BYTE_DATA" },
> > 		[...]
> > 		{ I2C_SMBUS_I2C_BLOCK_DATA,	"I2C_BLOCK_DATA"}), ...
> 
> What happens if the number isn't in the table?

It simply prints the hex value. See trace_output.c:

const char *
ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
			 const struct trace_print_flags *symbol_array)
{
	int i;
	const char *ret = p->buffer + p->len;

	for (i = 0;  symbol_array[i].name; i++) {

		if (val != symbol_array[i].mask)
			continue;

		trace_seq_puts(p, symbol_array[i].name);
		break;
	}

	if (ret == (const char *)(p->buffer + p->len))
		trace_seq_printf(p, "0x%lx", val);
		
	trace_seq_putc(p, 0);

	return ret;
}

-- Steve

