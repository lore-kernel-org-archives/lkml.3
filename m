Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbbATOsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:48:14 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43711 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbATOsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:48:12 -0500
MIME-Version: 1.0
In-Reply-To: <1421764441-11928-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1421764441-11928-1-git-send-email-pantelis.antoniou@konsulko.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 20 Jan 2015 08:47:49 -0600
Message-ID: <CAL_JsqLVJjq3Ov=J-5LtXiTQPLvR5Y=+tB1i16k_rN3j5dODFQ@mail.gmail.com>
Subject: Re: [PATCH] of: Custom printk format specifier for device node
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 8:34 AM, Pantelis Antoniou
<pantelis.antoniou@konsulko.com> wrote:
> 90% of the usage of device node's full_name is printing it out
> in a kernel message. Preparing for the eventual delayed allocation
> introduce a custom printk format specifier that is both more
> compact and more pleasant to the eye.

What a great idea. ;)

> For instance typical use is:
>         pr_info("Frobbing node %s\n", node->full_name);
>
> Which can be written now as:
>         pr_info("Frobbing node %pO\n", node);
>
> A verbose format specifier (1-2) can be used to print extra
> information about the node like its phandle and node flags.
>
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> ---
>  Documentation/printk-formats.txt | 18 +++++++++++
>  lib/vsprintf.c                   | 67 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 85 insertions(+)
>
> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> index 5a615c1..6ad199f 100644
> --- a/Documentation/printk-formats.txt
> +++ b/Documentation/printk-formats.txt
> @@ -231,6 +231,24 @@ struct va_format:
>         Do not use this feature without some mechanism to verify the
>         correctness of the format string and va_list arguments.
>
> +Device tree nodes:
> +
> +       %pO{,1,2}

'O' is not very obvious, but I imagine we are somewhat limted in our
choice here?

> +
> +       For printing device tree nodes. The (optional) number is the verbosity
> +       level.
> +
> +       Examples:
> +
> +       %pO     /foo/bar@0              - Node full name
> +       %pO0    /foo/bar@0              - Same as above
> +       %pO1    /foo/bar@0[10]          - Node full name + phandle
> +       %pO2    /foo/bar@0[10:DdPB]     - Node full name + phandle + node flags
> +                                        D - dynamic
> +                                        d - detached
> +                                        P - Populated
> +                                        B - Populated bus

We should think about what else we want to print for a node. Perhaps
'On' for name, 'Oc' for compatible, etc.

> +
>  u64 SHOULD be printed with %llu/%llx:
>
>         printk("%llu", u64_var);
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index ec337f6..72896cc 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -29,6 +29,7 @@
>  #include <linux/dcache.h>
>  #include <linux/cred.h>
>  #include <net/addrconf.h>
> +#include <linux/of.h>
>
>  #include <asm/page.h>          /* for PAGE_SIZE */
>  #include <asm/sections.h>      /* for dereference_function_descriptor() */
> @@ -1240,6 +1241,68 @@ char *address_val(char *buf, char *end, const void *addr,
>         return number(buf, end, num, spec);
>  }
>
> +#if IS_ENABLED(CONFIG_OF)

You can move this into the function:

if (!IS_ENABLED(CONFIG_OF)
  return NULL;

Looks like you'll need the patch for empty of_node_check_flag as well.

> +static noinline_for_stack
> +char *device_node_string(char *buf, char *end, struct device_node *dn,
> +                        struct printf_spec spec, const char *fmt)
> +{
> +       char tbuf[sizeof("[xxxxxxxxxx:xxxx]") + 1];
> +       const char *full_name;
> +       int verbosity, len, flen, i;
> +
> +       if ((unsigned long)dn < PAGE_SIZE)
> +               return string(buf, end, "(null)", spec);
> +
> +       full_name = of_node_full_name(dn);
> +       verbosity = 0;
> +       if (fmt[1] >= '0' && fmt[1] <= '2')
> +               verbosity = fmt[1] - '0';
> +
> +       /* fast and simple case */
> +       switch (verbosity) {
> +       default:
> +       case 0:
> +               tbuf[0] = '\0';
> +               break;
> +       case 1:
> +               snprintf(tbuf, sizeof(tbuf), "[%u]",
> +                       (u32)dn->phandle);
> +               break;
> +       case 2:
> +               snprintf(tbuf, sizeof(tbuf), "[%u:%c%c%c%c]",
> +                       (u32)dn->phandle,
> +                       of_node_check_flag(dn, OF_DYNAMIC) ? 'D' : '-',
> +                       of_node_check_flag(dn, OF_DETACHED) ? 'd' : '-',
> +                       of_node_check_flag(dn, OF_POPULATED) ? 'P' : '-',
> +                       of_node_check_flag(dn, OF_POPULATED_BUS) ? 'B' : '-');
> +               break;
> +       }
> +       flen = strlen(full_name);
> +       len = flen + strlen(tbuf);
> +       if (spec.precision > 0 && len > spec.precision)
> +               len = spec.precision;
> +
> +       if (!(spec.flags & LEFT)) {
> +               while (len < spec.field_width--) {
> +                       if (buf < end)
> +                               *buf = ' ';
> +                       ++buf;
> +               }
> +       }
> +       for (i = 0; i < len; ++i) {
> +               if (buf < end)
> +                       *buf = i < flen ? full_name[i] : tbuf[i - flen];
> +               ++buf;
> +       }
> +       while (len < spec.field_width--) {
> +               if (buf < end)
> +                       *buf = ' ';
> +               ++buf;
> +       }
> +       return buf;
> +}
> +#endif
> +
>  int kptr_restrict __read_mostly;
>
>  /*
> @@ -1459,6 +1522,10 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>                 return dentry_name(buf, end,
>                                    ((const struct file *)ptr)->f_path.dentry,
>                                    spec, fmt);
> +#if IS_ENABLED(CONFIG_OF)

With the above, then this ifdef should not be needed.

> +       case 'O':
> +               return device_node_string(buf, end, ptr, spec, fmt);
> +#endif
>         }
>         spec.flags |= SMALL;
>         if (spec.field_width == -1) {
> --
> 1.7.12
>
