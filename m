Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaLRE0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 23:26:19 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:35379 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaLRE0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 23:26:18 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 18 Dec 2014 13:26:32 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tools lib traceevent: Add support for IP address formats
Message-ID: <20141218042632.GB20215@sejong>
References: <1418848148-35919-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418848148-35919-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, Dec 17, 2014 at 01:29:08PM -0700, David Ahern wrote:
> Adds helper for following kernel formats:
>   %pi4 print an IPv4 address with leading zeros
>   %pI4 print an IPv4 address without leading zeros
>   %pi6 print an IPv6 address without colons
>   %pI6 print an IPv6 address with colons
>   %pI6c print an IPv6 address with colons
>   %pISpc print an IP address from a sockaddr
> 
> Allows these formats to be used in tracepoints.
> 
> Quite a bit of this is adapted from code in lib/vsprintf.c.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---

[SNIP]
> +static int print_ip_arg(struct trace_seq *s, const char *ptr,
> +			void *data, int size, struct event_format *event,
> +			struct print_arg *arg)
> +{
> +	char i = *(ptr + 1);  /* 'i' or 'I' */

It'd be better if we do it like below..

	char i = *ptr++;

Why not passing ptr + 1 to print_ip_arg()?


> +	char ver;
> +	int rc = 0;
> +
> +	ptr++;
> +	rc++;
> +
> +	ver = *(ptr + 1);

Ditto.


> +	ptr++;
> +	rc++;
> +
> +	switch (ver) {
> +	case '4':
> +		rc += print_ipv4_arg(s, ptr, i, data, size, event, arg);
> +		break;
> +	case '6':
> +		rc += print_ipv6_arg(s, ptr, i, data, size, event, arg);
> +		break;
> +	case 'S':
> +		rc += print_ipsa_arg(s, ptr, i, data, size, event, arg);
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return rc;
> +}
> +
>  static int is_printable_array(char *p, unsigned int len)
>  {
>  	unsigned int i;
> @@ -4337,6 +4644,15 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
>  					ptr++;
>  					arg = arg->next;
>  					break;
> +				} else if (*(ptr+1) == 'I' || *(ptr+1) == 'i') {
> +					int n;
> +
> +					n = print_ip_arg(s, ptr, data, size, event, arg);

Here..

Thanks,
Namhyung


> +					if (n > 0) {
> +						ptr += n;
> +						arg = arg->next;
> +						break;
> +					}
>  				}
>  
>  				/* fall through */
> -- 
> 1.9.3 (Apple Git-50)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
