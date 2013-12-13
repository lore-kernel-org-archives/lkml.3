Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3LMSN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 13:13:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:45872 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753272Ab3LMSN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 13:13:56 -0500
Date: Fri, 13 Dec 2013 13:13:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Howells <dhowells@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wolfram@the-dreams.de>
Subject: Re: [PATCH] i2c: Add message transfer tracepoints for I2C and SMBUS
Message-ID: <20131213131353.17d49ac4@gandalf.local.home>
In-Reply-To: <18214.1386955613@warthog.procyon.org.uk>
References: <20131213175350.0c4a95d5@endymion.delvare>
	<20131213163349.4bc686c0@endymion.delvare>
	<20131213142627.4014.42860.stgit@warthog.procyon.org.uk>
	<3708.1386950736@warthog.procyon.org.uk>
	<18214.1386955613@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013 17:26:53 +0000
David Howells <dhowells@redhat.com> wrote:

> index ed366e145c8d..ca19f4948290 100644
> --- a/include/trace/events/i2c.h
> +++ b/include/trace/events/i2c.h
> @@ -23,42 +23,259 @@
>  extern void i2c_transfer_trace_reg(void);
>  extern void i2c_transfer_trace_unreg(void);
>  
> -TRACE_EVENT_FN(i2c_transfer,
> +/*
> + * __i2c_transfer() write request
> + */
> +TRACE_EVENT_FN(i2c_write,
>  	       TP_PROTO(const struct i2c_adapter *adap, const struct i2c_msg *msg,
> -			int ret),
> -	       TP_ARGS(adap, msg, ret),
> +			int num),
> +	       TP_ARGS(adap, msg, num),
>  	       TP_STRUCT__entry(
> -		       __field(	int,	adapter_nr		)
> +		       __field(int,	adapter_nr		)
> +		       __field(__u16,	msg_nr			)
>  		       __field(__u16,	addr			)
>  		       __field(__u16,	flags			)
>  		       __field(__u16,	len			)
> -		       __field(__s16,	ret			)
>  		       __dynamic_array(__u8, buf, msg->len)	),
>  	       TP_fast_assign(
>  		       __entry->adapter_nr = adap->nr;
> +		       __entry->msg_nr = num;
> +		       __entry->addr = msg->addr;
> +		       __entry->flags = msg->flags;
> +		       __entry->len = msg->len;
> +		       memcpy(__get_dynamic_array(buf), msg->buf, msg->len);
> +			      ),
> +	       TP_printk("i2c-%d #%u f=%02x a=%02x l=%u [%*phN]",
> +			 __entry->adapter_nr,
> +			 __entry->msg_nr,
> +			 __entry->flags,
> +			 __entry->addr,
> +			 __entry->len,
> +			 __entry->len, __get_dynamic_array(buf)
> +			 ),
> +	       i2c_transfer_trace_reg,
> +	       i2c_transfer_trace_unreg);
> +
> +/*
> + * __i2c_transfer() read request
> + */
> +TRACE_EVENT_FN(i2c_read,
> +	       TP_PROTO(const struct i2c_adapter *adap, const struct i2c_msg *msg,
> +			int num),
> +	       TP_ARGS(adap, msg, num),
> +	       TP_STRUCT__entry(
> +		       __field(int,	adapter_nr		)
> +		       __field(__u16,	msg_nr			)
> +		       __field(__u16,	addr			)
> +		       __field(__u16,	flags			)
> +		       __field(__u16,	len			)
> +				),
> +	       TP_fast_assign(
> +		       __entry->adapter_nr = adap->nr;
> +		       __entry->msg_nr = num;
> +		       __entry->addr = msg->addr;
> +		       __entry->flags = msg->flags;
> +		       __entry->len = msg->len;
> +			      ),
> +	       TP_printk("i2c-%d #%u f=%02x a=%02x l=%u",
> +			 __entry->adapter_nr,
> +			 __entry->msg_nr,
> +			 __entry->flags,
> +			 __entry->addr,
> +			 __entry->len
> +			 ),
> +	       i2c_transfer_trace_reg,
> +		       i2c_transfer_trace_unreg);
> +

Now that you have two tracepoints that are identical, you can use
DECLARE_EVENT_CLASS() and DEFINE_EVENT_FN(). That is:

DECLARE_EVENT_CLASS(i2c_read_write,
	       TP_PROTO(const struct i2c_adapter *adap, const struct i2c_msg *msg,
			int num),
	       TP_ARGS(adap, msg, num),
	       TP_STRUCT__entry(
		       __field(int,	adapter_nr		)
	               __field(__u16,   msg_nr			)
                       __field(__u16,   addr			)
                       __field(__u16,   flags			)
                       __field(__u16,   len			)),
	       TP_fast_assign(
		       __entry->adapter_nr = adap->nr;
		       __entry->msg_nr = num;
		       __entry->addr = msg->addr;
		       __entry->flags = msg->flags;
		       __entry->len = msg->len;
			      ),
	       TP_printk("i2c-%d #%u f=%02x a=%02x l=%u",
			 __entry->adapter_nr,
			 __entry->msg_nr,
			 __entry->flags,
			 __entry->addr,
			 __entry->len
			 )
		);

DEFINE_EVENT_FN(i2c_read_write, i2c_read,
	       TP_PROTO(const struct i2c_adapter *adap, const struct i2c_ msg *msg,
			int num),
	       TP_ARGS(adap, msg, num),
	       i2c_transfer_trace_reg,
	       i2c_transfer_trace_unreg);

DEFINE_EVENT_FN(i2c_read_write, i2c_write,
	       TP_PROTO(const struct i2c_adapter *adap, const struct i2c_ msg *msg,
			int num),
	       TP_ARGS(adap, msg, num),
	       i2c_transfer_trace_reg,
	       i2c_transfer_trace_unreg);

This will reduce duplication of code by several kilobytes.


-- Steve

