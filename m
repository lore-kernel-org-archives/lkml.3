Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaLRPxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:53:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:36307 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaLRPxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:53:05 -0500
Date: Thu, 18 Dec 2014 12:52:55 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tools lib traceevent: Add support for IP address formats
Message-ID: <20141218155255.GF3150@kernel.org>
References: <1418915443-45707-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418915443-45707-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 18, 2014 at 08:10:43AM -0700, David Ahern escreveu:
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

Can't we try as much as possible use that code directly? Something like
we do for lib/rbtree.c in tools/perf/, or like I did recently with
tools/lib/util/find_next_bit.c, i.e. retain at least this kind of
sharing:

diff -u tools/lib/util/find_next_bit.c  lib/find_next_bit.c

Should show that only bits that we have not a need at the moment in
tools/ were left behind.

We want to either get fixes for free by directly reusing or notice it
easily, using diff.

- Arnaldo
 
> v2:
> - pass ptr+1 to print_ip_arg per Namhyung's comments
> - added field length checks to sockaddr function
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  tools/lib/traceevent/event-parse.c | 326 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 326 insertions(+)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index cf3a44bf1ec3..48d57c9fc476 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -32,6 +32,7 @@
>  #include <stdint.h>
>  #include <limits.h>
>  
> +#include <netinet/ip6.h>
>  #include "event-parse.h"
>  #include "event-utils.h"
>  
> @@ -4149,6 +4150,322 @@ static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
>  	trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3], buf[4], buf[5]);
>  }
>  
> +static void print_ip4_addr(struct trace_seq *s, char i, unsigned char *buf)
> +{
> +	const char *fmt;
> +
> +	if (i == 'i')
> +		fmt = "%03d.%03d.%03d.%03d";
> +	else
> +		fmt = "%d.%d.%d.%d";
> +
> +	trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3]);
> +}
> +
> +static inline bool ipv6_addr_v4mapped(const struct in6_addr *a)
> +{
> +	return ((unsigned long)(a->s6_addr32[0] | a->s6_addr32[1]) |
> +		(unsigned long)(a->s6_addr32[2] ^ htonl(0x0000ffff))) == 0UL;
> +}
> +
> +static inline bool ipv6_addr_is_isatap(const struct in6_addr *addr)
> +{
> +	return (addr->s6_addr32[2] | htonl(0x02000000)) == htonl(0x02005EFE);
> +}
> +
> +static void print_ip6c_addr(struct trace_seq *s, unsigned char *addr)
> +{
> +	int i, j, range;
> +	unsigned char zerolength[8];
> +	int longest = 1;
> +	int colonpos = -1;
> +	uint16_t word;
> +	uint8_t hi, lo;
> +	bool needcolon = false;
> +	bool useIPv4;
> +	struct in6_addr in6;
> +
> +	memcpy(&in6, addr, sizeof(struct in6_addr));
> +
> +	useIPv4 = ipv6_addr_v4mapped(&in6) || ipv6_addr_is_isatap(&in6);
> +
> +	memset(zerolength, 0, sizeof(zerolength));
> +
> +	if (useIPv4)
> +		range = 6;
> +	else
> +		range = 8;
> +
> +	/* find position of longest 0 run */
> +	for (i = 0; i < range; i++) {
> +		for (j = i; j < range; j++) {
> +			if (in6.s6_addr16[j] != 0)
> +				break;
> +			zerolength[i]++;
> +		}
> +	}
> +	for (i = 0; i < range; i++) {
> +		if (zerolength[i] > longest) {
> +			longest = zerolength[i];
> +			colonpos = i;
> +		}
> +	}
> +	if (longest == 1)		/* don't compress a single 0 */
> +		colonpos = -1;
> +
> +	/* emit address */
> +	for (i = 0; i < range; i++) {
> +		if (i == colonpos) {
> +			if (needcolon || i == 0)
> +				trace_seq_printf(s, ":");
> +			trace_seq_printf(s, ":");
> +			needcolon = false;
> +			i += longest - 1;
> +			continue;
> +		}
> +		if (needcolon) {
> +			trace_seq_printf(s, ":");
> +			needcolon = false;
> +		}
> +		/* hex u16 without leading 0s */
> +		word = ntohs(in6.s6_addr16[i]);
> +		hi = word >> 8;
> +		lo = word & 0xff;
> +		if (hi)
> +			trace_seq_printf(s, "%x%02x", hi, lo);
> +		else
> +			trace_seq_printf(s, "%x", lo);
> +
> +		needcolon = true;
> +	}
> +
> +	if (useIPv4) {
> +		if (needcolon)
> +			trace_seq_printf(s, ":");
> +		print_ip4_addr(s, 'I', &in6.s6_addr[12]);
> +	}
> +
> +	return;
> +}
> +
> +static void print_ip6_addr(struct trace_seq *s, char i, unsigned char *buf)
> +{
> +	int j;
> +
> +	for (j = 0; j < 16; j += 2) {
> +		trace_seq_printf(s, "%02x%02x", buf[j], buf[j+1]);
> +		if (i == 'I' && j < 14)
> +			trace_seq_printf(s, ":");
> +	}
> +}
> +
> +/*
> + * %pi4   print an IPv4 address with leading zeros
> + * %pI4   print an IPv4 address without leading zeros
> + * %pi6   print an IPv6 address without colons
> + * %pI6   print an IPv6 address with colons
> + * %pI6c  print an IPv6 address in compressed form with colons
> + * %pISpc print an IP address based on sockaddr; p adds port.
> + */
> +static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
> +			  void *data, int size, struct event_format *event,
> +			  struct print_arg *arg)
> +{
> +	unsigned char *buf;
> +
> +	if (arg->type == PRINT_FUNC) {
> +		process_defined_func(s, data, size, event, arg);
> +		return 0;
> +	}
> +
> +	if (arg->type != PRINT_FIELD) {
> +		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
> +		return 0;
> +	}
> +
> +	if (!arg->field.field) {
> +		arg->field.field =
> +			pevent_find_any_field(event, arg->field.name);
> +		if (!arg->field.field) {
> +			do_warning("%s: field %s not found",
> +				   __func__, arg->field.name);
> +			return 0;
> +		}
> +	}
> +
> +	buf = data + arg->field.field->offset;
> +
> +	if (arg->field.field->size != 4) {
> +		trace_seq_printf(s, "INVALIDIPv4");
> +		return 0;
> +	}
> +	print_ip4_addr(s, i, buf);
> +
> +	return 0;
> +}
> +
> +static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
> +			  void *data, int size, struct event_format *event,
> +			  struct print_arg *arg)
> +{
> +	char have_c = 0;
> +	unsigned char *buf;
> +	int rc = 0;
> +
> +	/* pI6c */
> +	if (*ptr == 'c') {
> +		have_c = 1;
> +		ptr++;
> +		rc++;
> +	}
> +
> +	if (arg->type == PRINT_FUNC) {
> +		process_defined_func(s, data, size, event, arg);
> +		return rc;
> +	}
> +
> +	if (arg->type != PRINT_FIELD) {
> +		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
> +		return rc;
> +	}
> +
> +	if (!arg->field.field) {
> +		arg->field.field =
> +			pevent_find_any_field(event, arg->field.name);
> +		if (!arg->field.field) {
> +			do_warning("%s: field %s not found",
> +				   __func__, arg->field.name);
> +			return rc;
> +		}
> +	}
> +
> +	buf = data + arg->field.field->offset;
> +
> +	if (arg->field.field->size != 16) {
> +		trace_seq_printf(s, "INVALIDIPv6");
> +		return rc;
> +	}
> +
> +	if (have_c)
> +		print_ip6c_addr(s, buf);
> +	else
> +		print_ip6_addr(s, i, buf);
> +
> +	return rc;
> +}
> +
> +static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
> +			  void *data, int size, struct event_format *event,
> +			  struct print_arg *arg)
> +{
> +	char have_c = 0, have_p = 0;
> +	unsigned char *buf;
> +	struct sockaddr_storage *sa;
> +	int rc = 0;
> +
> +	/* pISpc */
> +	if (*ptr == 'p') {
> +		have_p = 1;
> +		ptr++;
> +		rc++;
> +	}
> +	if (*ptr == 'c') {
> +		have_c = 1;
> +		ptr++;
> +		rc++;
> +	}
> +
> +	if (arg->type == PRINT_FUNC) {
> +		process_defined_func(s, data, size, event, arg);
> +		return rc;
> +	}
> +
> +	if (arg->type != PRINT_FIELD) {
> +		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
> +		return rc;
> +	}
> +
> +	if (!arg->field.field) {
> +		arg->field.field =
> +			pevent_find_any_field(event, arg->field.name);
> +		if (!arg->field.field) {
> +			do_warning("%s: field %s not found",
> +				   __func__, arg->field.name);
> +			return rc;
> +		}
> +	}
> +
> +	sa = (struct sockaddr_storage *) (data + arg->field.field->offset);
> +
> +	if (sa->ss_family == AF_INET) {
> +		struct sockaddr_in *sa4 = (struct sockaddr_in *) sa;
> +
> +		if (arg->field.field->size < sizeof(struct sockaddr_in)) {
> +			trace_seq_printf(s, "INVALIDIPv4");
> +			return rc;
> +		}
> +
> +		print_ip4_addr(s, i, (unsigned char *) &sa4->sin_addr);
> +		if (have_p)
> +			trace_seq_printf(s, ":%d", ntohs(sa4->sin_port));
> +
> +
> +	} else if (sa->ss_family == AF_INET6) {
> +		struct sockaddr_in6 *sa6 = (struct sockaddr_in6 *) sa;
> +
> +		if (arg->field.field->size < sizeof(struct sockaddr_in6)) {
> +			trace_seq_printf(s, "INVALIDIPv6");
> +			return rc;
> +		}
> +
> +		if (have_p)
> +			trace_seq_printf(s, "[");
> +
> +		buf = (unsigned char *) &sa6->sin6_addr;
> +		if (have_c)
> +			print_ip6c_addr(s, buf);
> +		else
> +			print_ip6_addr(s, i, buf);
> +
> +		if (have_p)
> +			trace_seq_printf(s, "]:%d", ntohs(sa6->sin6_port));
> +	}
> +
> +	return rc;
> +}
> +
> +static int print_ip_arg(struct trace_seq *s, const char *ptr,
> +			void *data, int size, struct event_format *event,
> +			struct print_arg *arg)
> +{
> +	char i = *ptr;  /* 'i' or 'I' */
> +	char ver;
> +	int rc = 0;
> +
> +	ptr++;
> +	rc++;
> +
> +	ver = *ptr;
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
> @@ -4337,6 +4654,15 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
>  					ptr++;
>  					arg = arg->next;
>  					break;
> +				} else if (*(ptr+1) == 'I' || *(ptr+1) == 'i') {
> +					int n;
> +
> +					n = print_ip_arg(s, ptr+1, data, size, event, arg);
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
