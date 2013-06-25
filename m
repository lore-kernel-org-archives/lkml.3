Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab3FYQkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:40:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47635 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751195Ab3FYQkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:40:21 -0400
Message-ID: <1372178420.1245.59.camel@joe-AO722>
Subject: Re: [PATCH] staging: ozwpan: Convert printk to dev_dbg()
From: Joe Perches <joe@perches.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        shigekatsu.tateno@atmel.com
Date: Tue, 25 Jun 2013 09:40:20 -0700
In-Reply-To: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>
References: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 17:30 +0100, Rupesh Gujare wrote:
> convert all debug messages from printk to dev_dbg() & add kernel config to
> enable/disable these messages during compilation.
[]
> -#define oz_trace(...) printk(TRACE_PREFIX __VA_ARGS__)
> +#define oz_trace(fmt, ...) dev_dbg(g_oz_wpan_dev, fmt, ##__VA_ARGS__);
>  #ifdef WANT_VERBOSE_TRACE
>  extern unsigned long trace_flags;
> -#define oz_trace2(_flag, ...) \
> -	do { if (trace_flags & _flag) printk(TRACE_PREFIX __VA_ARGS__); \
> +#define oz_trace2(_flag, fmt, ...) \
> +	do { if (trace_flags & _flag) \
> +		dev_dbg(g_oz_wpan_dev, fmt, ##__VA_ARGS__); \
>  	} while (0)

I think oz_trace is a poor name.
It implies you're using the trace subsystem
trace_flags as a global name is also poor
g_oz_wpan_dev is too as it limits the module to
a single dev instance.

I suggest:

#define oz_dbg(level, fmt, ...)					\
do {								\
	if (level & oz_dbg_mask)				\
		dev_dbg(g_oz_wpan_dev, fmt, ##__VA_ARGS__);	\
} while (0)

or better avoiding the single dev:

#define oz_dbg(level, dev, fmt, ...)				\
do {								\
	if (level & oz_dbg_mask)				\
		dev_dbg(dev, fmt, ##__VA_ARGS__);		\
} while (0)

