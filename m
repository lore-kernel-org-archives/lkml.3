Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbbAVUbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:31:55 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:53205 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbbAVUbx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:31:53 -0500
Subject: Re: [PATCH] of: Custom printk format specifier for device node
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=windows-1252
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1421861843.10574.23.camel@perches.com>
Date: Thu, 22 Jan 2015 22:31:46 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7EBFDD59-156A-42FB-AAF0-CE4A88219794@antoniou-consulting.com>
References: <1421859974-24507-1-git-send-email-pantelis.antoniou@konsulko.com> <1421861843.10574.23.camel@perches.com>
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> On Jan 21, 2015, at 19:37 , Joe Perches <joe@perches.com> wrote:
> 
> On Wed, 2015-01-21 at 19:06 +0200, Pantelis Antoniou wrote:
>> 90% of the usage of device node's full_name is printing it out
>> in a kernel message. Preparing for the eventual delayed allocation
>> introduce a custom printk format specifier that is both more
>> compact and more pleasant to the eye.
>> 
>> For instance typical use is:
>> 	pr_info("Frobbing node %s\n", node->full_name);
>> 
>> Which can be written now as:
>> 	pr_info("Frobbing node %pO\n", node);

> Still disliking use of %p0.
> 

pO - Open Firmware

pT for tree is bad, cause we plan to use a tree type in the future in OF.

>> More fine-grained control of formatting includes printing the name,
>> flag, path-spec name, reference count and others, explained in the
>> documentation entry.
>> 
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>> 
>> dt-print
>> ---
>> Documentation/printk-formats.txt |  29 ++++++++
>> lib/vsprintf.c                   | 151 +++++++++++++++++++++++++++++++++++++++
>> 2 files changed, 180 insertions(+)
>> 
>> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
>> index 5a615c1..2d42c04 100644
>> --- a/Documentation/printk-formats.txt
>> +++ b/Documentation/printk-formats.txt
>> @@ -231,6 +231,35 @@ struct va_format:
>> 	Do not use this feature without some mechanism to verify the
>> 	correctness of the format string and va_list arguments.
>> 
>> +Device tree nodes:
>> +
>> +	%pO[fnpPcCFr]
>> +
>> +	For printing device tree nodes. The optional arguments are:
>> +            f device node full_name
>> +            n device node name
>> +            p device node phandle
>> +            P device node path spec (name + @unit)
>> +            F device node flags
>> +            c major compatible string
>> +            C full compatible string
>> +            r node reference count
>> +	Without any arguments prints full_name (same as %pOf)
>> +	The separator when using multiple arguments is '|'
>> +
>> +	Examples:
>> +
>> +	%pO	/foo/bar@0			- Node full name
>> +	%pOf	/foo/bar@0			- Same as above
>> +	%pOfp	/foo/bar@0|10			- Node full name + phandle
>> +	%pOfcF	/foo/bar@0|foo,device|--P-	- Node full name +
>> +	                                          major compatible string +
>> +						  node flags
>> +							D - dynamic
>> +							d - detached
>> +							P - Populated
>> +							B - Populated bus
>> +
>> u64 SHOULD be printed with %llu/%llx:
>> 
>> 	printk("%llu", u64_var);
>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
> 
> Add #ifdef back ?
> 

The whole thing is optimized away when CONFIG_OF is not defined, leaving only
the return statement.

>> +static noinline_for_stack
>> +char *device_node_string(char *buf, char *end, struct device_node *dn,
>> +			 struct printf_spec spec, const char *fmt)
>> +{
>> +	char tbuf[sizeof("xxxxxxxxxx") + 1];
>> +	const char *fmtp, *p;
>> +	int len, ret, i, j, pass;
>> +	char c;
>> +
>> +	if (!IS_ENABLED(CONFIG_OF))
>> +		return string(buf, end, "(!OF)", spec);
> 
> Not very descriptive output, maybe the address would be better.
> 

OK

>> +
>> +	if ((unsigned long)dn < PAGE_SIZE)
>> +		return string(buf, end, "(null)", spec);
>> +
>> +	/* simple case without anything any more format specifiers */
>> +	if (fmt[1] == '\0' || isspace(fmt[1]))
>> +		fmt = "Of";
> 
> why lower case here but upper case above?
> 

Cause '(null)' is what’s printed in string() when null is passed as a pointer.

>> +
>> +	len = 0;
>> +
>> +	/* two passes; the first calculates length, the second fills in */
>> +	for (pass = 1; pass <= 2; pass++) {
>> +		if (pass == 2 && !(spec.flags & LEFT)) {
>> +			/* padding */
>> +			while (len < spec.field_width--) {
>> +				if (buf < end)
>> +					*buf = ' ';
>> +				++buf;
>> +			}
>> +		}
>> +#undef _HANDLE_CH
>> +#define _HANDLE_CH(_ch) \
>> +	do { \
>> +		if (pass == 1) \
>> +			len++; \
>> +		else \
>> +			if (buf < end) \
>> +				*buf++ = (_ch); \
>> +	} while (0)
>> +#undef _HANDLE_STR
>> +#define _HANDLE_STR(_str) \
>> +	do { \
>> +		const char *str = (_str); \
>> +		if (pass == 1) \
>> +			len += strlen(str); \
>> +		else \
>> +			while (*str && buf < end) \
>> +				*buf++ = *str++; \
>> +	} while (0)
> 
> This isn't pretty.  Perhaps there's a better way?
> 

It’s the simplest way to do the different operations for the two passes, without
bloating the code or adding superfluous methods.

We don’t want to allocate memory, we don’t want to use stack space. We’re probably
printing in atomic context too since device nodes don’t usually printed out
during normal operation.
  
>> +
>> +		for (fmtp = fmt + 1, j = 0; (c = *fmtp++) != '\0'; ) {
>> +			switch (c) {
>> +			case 'f':	/* full_name */
>> +				if (j++ > 0)
>> +					_HANDLE_CH(':');
>> +				_HANDLE_STR(of_node_full_name(dn));
>> +				break;
>> +			case 'n':	/* name */
>> +				if (j++ > 0)
>> +					_HANDLE_CH('|');
>> +				_HANDLE_STR(dn->name);
>> +				break;
>> +			case 'p':	/* phandle */
>> +				if (j++ > 0)
>> +					_HANDLE_CH('|');
>> +				snprintf(tbuf, sizeof(tbuf), "%u",
>> +						(unsigned int)dn->phandle);
>> +				_HANDLE_STR(tbuf);
>> +				break;
>> +			case 'P':	/* path-spec */
>> +				if (j++ > 0)
>> +					_HANDLE_CH('|');
>> +				_HANDLE_STR(dn->name);
>> +				/* need to tack on the @ postfix */
>> +				p = strchr(of_node_full_name(dn), '@');
>> +				if (p)
>> +					_HANDLE_STR(p);
>> +				break;
>> +			case 'F':	/* flags */
>> +				if (j++ > 0)
>> +					_HANDLE_CH('|');
>> +				snprintf(tbuf, sizeof(tbuf), "%c%c%c%c",
>> +					of_node_check_flag(dn, OF_DYNAMIC) ?
>> +						'D' : '-',
>> +					of_node_check_flag(dn, OF_DETACHED) ?
>> +						'd' : '-',
>> +					of_node_check_flag(dn, OF_POPULATED) ?
>> +						'P' : '-',
>> +					of_node_check_flag(dn,
>> +						OF_POPULATED_BUS) ?  'B' : '-');
>> +				_HANDLE_STR(tbuf);
>> +				break;
>> +			case 'c':	/* major compatible string */
>> +				if (j++ > 0)
>> +					_HANDLE_CH('|');
>> +				ret = of_property_read_string(dn, "compatible",
>> +						&p);
>> +				if (ret == 0)
>> +					_HANDLE_STR(p);
>> +				break;
>> +			case 'C':	/* full compatible string */
>> +				if (j++ > 0)
>> +					_HANDLE_CH('|');
>> +				i = 0;
>> +				while (of_property_read_string_index(dn,
>> +						"compatible", i, &p) == 0) {
>> +					if (i == 0)
>> +						_HANDLE_STR("\"");
>> +					else
>> +						_HANDLE_STR("\",\"");
>> +					_HANDLE_STR(p);
>> +					i++;
>> +				}
>> +				if (i > 0)
>> +					_HANDLE_STR("\"");
>> +				break;
>> +			case 'r':	/* node reference count */
>> +				if (j++ > 0)
>> +					_HANDLE_CH('|');
>> +				snprintf(tbuf, sizeof(tbuf), "%u",
>> +					atomic_read(&dn->kobj.kref.refcount));
>> +				_HANDLE_STR(tbuf);
>> +				break;
>> +			default:
>> +				break;
>> +			}
>> +		}
>> +	}
>> +	/* finish up */
>> +	while (buf < end && len < spec.field_width--)
>> +		*buf++ = ' ';
>> +#undef _HANDLE_CH
>> +#undef _HANDLE_STR
> 

Regards

— Pantelis

