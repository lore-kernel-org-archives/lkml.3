Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbaIDH5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:57:45 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:63849 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177AbaIDH5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:57:43 -0400
MIME-Version: 1.0
In-Reply-To: <1409814488.5546.63.camel@x220>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
	<1409814488.5546.63.camel@x220>
Date: Thu, 4 Sep 2014 09:57:42 +0200
Message-ID: <CAH6sp9PSAM+gd-7xmQYrFBVg6_-ovmx5PD7mef75BE8CfJVR4g@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: remove possible use of uninitialized value
From: Frans Klaver <fransklaver@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 9:08 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Thu, 2014-09-04 at 00:53 +0200, Frans Klaver wrote:
>> In store_sys_acpi, if count equals zero, or parse_arg()s sscanf call
>> fails, 'value' remains possibly uninitialized. In that case 'value'
>> shouldn't be used to produce the store_sys_acpi()s return value.
>>
>> Only test the return value of set_acpi() if we can actually call it.
>> Return rv otherwise.
>>
>> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
>> ---
>>  drivers/platform/x86/eeepc-laptop.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
>> index bd533c2..41f12ba 100644
>> --- a/drivers/platform/x86/eeepc-laptop.c
>> +++ b/drivers/platform/x86/eeepc-laptop.c
>> @@ -279,10 +279,10 @@ static ssize_t store_sys_acpi(struct device *dev, int cm,
>>       int rv, value;
>>
>>       rv = parse_arg(buf, count, &value);
>> -     if (rv > 0)
>> -             value = set_acpi(eeepc, cm, value);
>> -     if (value < 0)
>> -             return -EIO;
>> +     if (rv > 0) {
>> +             if (set_acpi(eeepc, cm, value) < 0)
>> +                     return -EIO;
>> +     }
>>       return rv;
>>  }
>>
>
> The warning that this code (currently) generated triggered me to submit
> https://lkml.org/lkml/2014/7/1/150 , which uses a different approach to
> get rid of it. I received no reactions so far. Here's that patch again:
>
> ------------>8------------
> From: Paul Bolle <pebolle@tiscali.nl>
> Subject: [PATCH] eeepc-laptop: simplify parse_arg()
>
> parse_arg() has three possible return values:
>     -EINVAL if sscanf(), in short, fails;
>     zero if "count" is zero; and
>     "count" in all other cases
>
> But "count" will never be zero. See, parse_arg() is called by the
> various store functions. And the callchain of these functions starts
> with sysfs_kf_write(). And that function checks for a zero "count". So
> we can stop checking for a zero "count", drop the "count" argument
> entirely, and transform parse_arg() into a function that returns zero on
> success or a negative error. That, in turn, allows to make those store
> functions just return "count" on success. The net effect is that the
> code becomes a bit easier to understand.
>
> A nice side effect is that this GCC warning is silenced too:
>     drivers/platform/x86/eeepc-laptop.c: In function ‘store_sys_acpi’:
>     drivers/platform/x86/eeepc-laptop.c:279:10: warning: ‘value’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>       int rv, value;
>
> Which is, of course, the reason to have a look at parse_arg().
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Curious. I hadn't found this one when searching for earlier patches.

Thanks,
Frans


> ---
>  drivers/platform/x86/eeepc-laptop.c | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index bd533c22be57..78515b850165 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -263,13 +263,11 @@ static int acpi_setter_handle(struct eeepc_laptop *eeepc, int cm,
>  /*
>   * Sys helpers
>   */
> -static int parse_arg(const char *buf, unsigned long count, int *val)
> +static int parse_arg(const char *buf, int *val)
>  {
> -       if (!count)
> -               return 0;
>         if (sscanf(buf, "%i", val) != 1)
>                 return -EINVAL;
> -       return count;
> +       return 0;
>  }
>
>  static ssize_t store_sys_acpi(struct device *dev, int cm,
> @@ -278,12 +276,13 @@ static ssize_t store_sys_acpi(struct device *dev, int cm,
>         struct eeepc_laptop *eeepc = dev_get_drvdata(dev);
>         int rv, value;
>
> -       rv = parse_arg(buf, count, &value);
> -       if (rv > 0)
> -               value = set_acpi(eeepc, cm, value);
> +       rv = parse_arg(buf, &value);
> +       if (rv < 0)
> +               return rv;
> +       value = set_acpi(eeepc, cm, value);
>         if (value < 0)
>                 return -EIO;
> -       return rv;
> +       return count;
>  }
>
>  static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
> @@ -377,13 +376,13 @@ static ssize_t store_cpufv(struct device *dev,
>                 return -EPERM;
>         if (get_cpufv(eeepc, &c))
>                 return -ENODEV;
> -       rv = parse_arg(buf, count, &value);
> +       rv = parse_arg(buf, &value);
>         if (rv < 0)
>                 return rv;
> -       if (!rv || value < 0 || value >= c.num)
> +       if (value < 0 || value >= c.num)
>                 return -EINVAL;
>         set_acpi(eeepc, CM_ASL_CPUFV, value);
> -       return rv;
> +       return count;
>  }
>
>  static ssize_t show_cpufv_disabled(struct device *dev,
> @@ -402,7 +401,7 @@ static ssize_t store_cpufv_disabled(struct device *dev,
>         struct eeepc_laptop *eeepc = dev_get_drvdata(dev);
>         int rv, value;
>
> -       rv = parse_arg(buf, count, &value);
> +       rv = parse_arg(buf, &value);
>         if (rv < 0)
>                 return rv;
>
> @@ -412,7 +411,7 @@ static ssize_t store_cpufv_disabled(struct device *dev,
>                         pr_warn("cpufv enabled (not officially supported "
>                                 "on this model)\n");
>                 eeepc->cpufv_disabled = false;
> -               return rv;
> +               return count;
>         case 1:
>                 return -EPERM;
>         default:
> @@ -1042,10 +1041,11 @@ static ssize_t store_sys_hwmon(void (*set)(int), const char *buf, size_t count)
>  {
>         int rv, value;
>
> -       rv = parse_arg(buf, count, &value);
> -       if (rv > 0)
> -               set(value);
> -       return rv;
> +       rv = parse_arg(buf, &value);
> +       if (rv < 0)
> +               return rv;
> +       set(value);
> +       return count;
>  }
>
>  static ssize_t show_sys_hwmon(int (*get)(void), char *buf)
> --
>
>
> Paul Bolle
>
