Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab3H0BDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:03:10 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:53527 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab3H0BDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:03:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAOLK0pxxAFBiDTac_5yPYO7X96Y4Tnd4kjwZ-Wvk1mZ3bD-w2A@mail.gmail.com>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
	<1376189294-32022-29-git-send-email-yinghai@kernel.org>
	<CANVTcTYhSfU+Su9s1B+mTTBfgsZgqvQxHiTsLck1zT_vg1Cs4g@mail.gmail.com>
	<CANVTcTb2+qX6XMBqrzeLho9yFS55AnztVJ85JBMuxjoH11qzaQ@mail.gmail.com>
	<CAOLK0pwQJVvcT5xA-+Ftb85FzbjHN-OZmXO=n7r4EWh4nFjSBA@mail.gmail.com>
	<CAE9FiQWnGaa6omcLW0zxLj+UMspRGxjVoYXUsH3ndydGD51T9w@mail.gmail.com>
	<CAE9FiQXFcM+FZnp00RP5Z8a2FhtjB7BuUUi4TuABF4-O9W+c8Q@mail.gmail.com>
	<CAE9FiQXMfTCSfK8no6gYmHYn6=OURg6444BPu-aiBR3BsAvziA@mail.gmail.com>
	<CAOLK0pxxAFBiDTac_5yPYO7X96Y4Tnd4kjwZ-Wvk1mZ3bD-w2A@mail.gmail.com>
Date: Mon, 26 Aug 2013 18:03:05 -0700
X-Google-Sender-Auth: B9cDWXcIIuVuEYY5v7F8pjO0D_E
Message-ID: <CAE9FiQXCMFMCSEZPa=viyJD9GokkbavJhSLtiEmaaFzR_aKi1w@mail.gmail.com>
Subject: Re: [PATCH v4 28/28] PCI, x86, ACPI: get ioapic address from acpi device
From: Yinghai Lu <yinghai@kernel.org>
To: Lan Tianyu <lantianyu1986@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        rui wang <ruiv.wang@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Linux PCI <linux-pci@vger.kernel.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 8:46 AM, Lan Tianyu <lantianyu1986@gmail.com> wrote:
> 2013/8/24 Yinghai Lu <yinghai@kernel.org>:
>> On Fri, Aug 23, 2013 at 12:04 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Fri, Aug 23, 2013 at 11:38 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>> On Fri, Aug 23, 2013 at 8:34 AM, Lan Tianyu <lantianyu1986@gmail.com> wrote:
>>>>>> I worked around the problem by replacing acpi_resource_to_address64()
>>>>>> with resource_to_addr().  But resource_to_addr() is a static function
>>>>>> in arch/x86/pci/acpi.c, not very convenient to use. Here's what I did:
>>>>>>
>>>>>
>>>>> Hi Rui&Yinghai:
>>>>>            How about using the following code to translate struct
>>>>>  acpi_resource to struct resouce in this setup_res()?
>>>>>
>>>>>          if (acpi_dev_resource_address_space(...)
>>>>>                 || acpi_dev_resource_memory(..))
>>>>>               return AE_OK;
>>>>
>>>> Yest, that could be better, will update that.
>>>>
>>>> Also can you submit patch that will use that in res_to_addr of
>>>> arch/x86/pci/acpi.c?
>>>
>>> looks acpi_dev_resource_address_space... does not handle
>>> PREFTCH and translation offset.
>>>
>>> So now i have to use res_to_addr alike one.
>>
>> Raphael,
>>
>> Maybe we should move resource_to_addr to acpi generic.
>>
>> Please check if you are ok with attached.
>>
>> Thanks
>>
>> Yinghai
>
> Hi Rafael & Yinghai:
>             I wrote 4 proposal patches to try to make acpi resource
> functions to replace
>  resource_to_addr() in the arch/x86/pci/acpi.c. From my opinion,
> resource_to_addr()
> does most work which acpi resource functions have done. So please have
> a look. Thanks.
> The following patches just passed through compiling test.

Thanks for doing that.

Overall it's Good to me.

some comments inline.

>
> Patch 1
> -------------------
> commit 1800bc9dda7318314607fbae7afda8be38e056dc
> Author: Lan Tianyu <tianyu.lan@intel.com>
> Date:   Mon Aug 26 14:40:39 2013 +0800
>
>     ACPI/Resource: Add setting PREFETCH flag support
>
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index b7201fc..23a560b 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -35,7 +35,7 @@
>  #endif
>
>  static unsigned long acpi_dev_memresource_flags(u64 len, u8 write_protect,
> -                        bool window)
> +                        bool window, bool prefetchable)
>  {
>      unsigned long flags = IORESOURCE_MEM;
>
> @@ -48,6 +48,9 @@ static unsigned long acpi_dev_memresource_flags(u64
> len, u8 write_protect,
>      if (window)
>          flags |= IORESOURCE_WINDOW;
>
> +    if (prefetchable)
> +        flags |= IORESOURCE_PREFETCH;
> +
>      return flags;
>  }
>
> @@ -56,7 +59,8 @@ static void acpi_dev_get_memresource(struct resource
> *res, u64 start, u64 len,
>  {
>      res->start = start;
>      res->end = start + len - 1;
> -    res->flags = acpi_dev_memresource_flags(len, write_protect, false);
> +    res->flags = acpi_dev_memresource_flags(len, write_protect,
> +                        false, false);
>  }

passing write_protect, window then pref looks silly.

may use | IO_REOURCE_... etc outside of acpi_dev_memresource_flags directly.

>
>  /**
> @@ -175,7 +179,7 @@ bool acpi_dev_resource_address_space(struct
> acpi_resource *ares,
>  {
>      acpi_status status;
>      struct acpi_resource_address64 addr;
> -    bool window;
> +    bool window, prefetchable;
>      u64 len;
>      u8 io_decode;
>
> @@ -199,9 +203,11 @@ bool acpi_dev_resource_address_space(struct
> acpi_resource *ares,
>      switch(addr.resource_type) {
>      case ACPI_MEMORY_RANGE:
>          len = addr.maximum - addr.minimum + 1;
> +        prefetchable =
> +            addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY;
>          res->flags = acpi_dev_memresource_flags(len,
>                          addr.info.mem.write_protect,
> -                        window);
> +                        window, prefetchable);
>          break;
>      case ACPI_IO_RANGE:
>          io_decode = addr.granularity == 0xfff ?
> @@ -252,7 +258,7 @@ bool acpi_dev_resource_ext_address_space(struct
> acpi_resource *ares,
>          len = ext_addr->maximum - ext_addr->minimum + 1;
>          res->flags = acpi_dev_memresource_flags(len,
>                      ext_addr->info.mem.write_protect,
> -                    window);
> +                    window, false);
>          break;
>      case ACPI_IO_RANGE:
>          io_decode = ext_addr->granularity == 0xfff ?
>
> Patch 2
> -----------
> commit a3ff8345ffb51885b216ba0ae231252cd88d4e76
> Author: Lan Tianyu <tianyu.lan@intel.com>
> Date:   Mon Aug 26 15:57:14 2013 +0800
>
>     ACPI/Resource: Add address translation support
>
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index 23a560b..439ee44 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -196,8 +196,8 @@ bool acpi_dev_resource_address_space(struct
> acpi_resource *ares,
>      if (ACPI_FAILURE(status))
>          return true;
>
> -    res->start = addr.minimum;
> -    res->end = addr.maximum;
> +    res->start = addr.minimum + addr.translation_offset;
> +    res->end = addr.maximum + addr.translation_offset;
>      window = addr.producer_consumer == ACPI_PRODUCER;
>
>      switch(addr.resource_type) {
>
>
> Patch 3
> ---------------
> commit 68bfefe619b49baa5d372e0664a6cb6d5138fad1
> Author: Lan Tianyu <tianyu.lan@intel.com>
> Date:   Mon Aug 26 21:45:32 2013 +0800
>
>     ACPI: Add new acpi_dev_resource_address_space_with_addr() function
>
>     Add new function which can return the converted struct
> acpi_resource_address64.
> This will be used to get transaction offset in the setup_resource().
>
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index 439ee44..98a6c35 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -174,11 +174,11 @@ EXPORT_SYMBOL_GPL(acpi_dev_resource_io);
>   * and if that's the case, use the information in it to populate the generic
>   * resource object pointed to by @res.
>   */
> -bool acpi_dev_resource_address_space(struct acpi_resource *ares,
> +bool acpi_dev_resource_address_space_with_addr(struct acpi_resource *ares,
> +                     struct acpi_resource_address64 *addr,
>                       struct resource *res)
>  {
>      acpi_status status;
> -    struct acpi_resource_address64 addr;
>      bool window, prefetchable;
>      u64 len;
>      u8 io_decode;
> @@ -192,28 +192,28 @@ bool acpi_dev_resource_address_space(struct
> acpi_resource *ares,
>          return false;
>      }
>
> -    status = acpi_resource_to_address64(ares, &addr);
> +    status = acpi_resource_to_address64(ares, addr);
>      if (ACPI_FAILURE(status))
>          return true;
>
> -    res->start = addr.minimum + addr.translation_offset;
> -    res->end = addr.maximum + addr.translation_offset;
> -    window = addr.producer_consumer == ACPI_PRODUCER;
> +    res->start = addr->minimum + addr->translation_offset;
> +    res->end = addr->maximum + addr->translation_offset;
> +    window = addr->producer_consumer == ACPI_PRODUCER;
>
> -    switch(addr.resource_type) {
> +    switch (addr->resource_type) {
>      case ACPI_MEMORY_RANGE:
> -        len = addr.maximum - addr.minimum + 1;
> +        len = addr->maximum - addr->minimum + 1;
>          prefetchable =
> -            addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY;
> +            addr->info.mem.caching == ACPI_PREFETCHABLE_MEMORY;
>          res->flags = acpi_dev_memresource_flags(len,
> -                        addr.info.mem.write_protect,
> +                        addr->info.mem.write_protect,
>                          window, prefetchable);
>          break;
>      case ACPI_IO_RANGE:
> -        io_decode = addr.granularity == 0xfff ?
> +        io_decode = addr->granularity == 0xfff ?
>                  ACPI_DECODE_10 : ACPI_DECODE_16;
> -        res->flags = acpi_dev_ioresource_flags(addr.minimum,
> -                               addr.maximum,
> +        res->flags = acpi_dev_ioresource_flags(addr->minimum,
> +                               addr->maximum,
>                                 io_decode, window);
>          break;
>      case ACPI_BUS_NUMBER_RANGE:
> @@ -225,6 +225,16 @@ bool acpi_dev_resource_address_space(struct
> acpi_resource *ares,
>
>      return true;
>  }
> +EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space_with_addr);
> +
> +bool acpi_dev_resource_address_space(struct acpi_resource *ares,
> +                     struct resource *res)
> +{
> +    struct acpi_resource_address64 addr;
> +
> +    return acpi_dev_resource_address_space_with_addr(ares, &addr,
> +                             res);
> +}
>  EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space);
>
>  /**
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index a5db4ae..9f5c0d5 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -260,6 +260,9 @@ bool acpi_dev_resource_memory(struct acpi_resource
> *ares, struct resource *res);
>  bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res);
>  bool acpi_dev_resource_address_space(struct acpi_resource *ares,
>                       struct resource *res);
> +bool acpi_dev_resource_address_space_with_addr(struct acpi_resource *ares,
> +                struct acpi_resource_address64 *addr,
> +                struct resource *res);
>  bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
>                       struct resource *res);
>  unsigned long acpi_dev_irq_flags(u8 triggering, u8 polarity, u8 shareable);
>
> Patch 4
> --------------
> commit a8733a1da756a257d55e68994268174b84b33670
> Author: Lan Tianyu <tianyu.lan@intel.com>
> Date:   Mon Aug 26 22:53:38 2013 +0800
>
>     X86/PCI/ACPI: Rework setup_resource() via functions acpi resource functions
>
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index d641897..d4f85a1 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -219,62 +219,15 @@ static void teardown_mcfg_map(struct pci_root_info *info)
>  #endif
>
>  static acpi_status
> -resource_to_addr(struct acpi_resource *resource,
> -            struct acpi_resource_address64 *addr)
> -{
> -    acpi_status status;
> -    struct acpi_resource_memory24 *memory24;
> -    struct acpi_resource_memory32 *memory32;
> -    struct acpi_resource_fixed_memory32 *fixed_memory32;
> -
> -    memset(addr, 0, sizeof(*addr));
> -    switch (resource->type) {
> -    case ACPI_RESOURCE_TYPE_MEMORY24:
> -        memory24 = &resource->data.memory24;
> -        addr->resource_type = ACPI_MEMORY_RANGE;
> -        addr->minimum = memory24->minimum;
> -        addr->address_length = memory24->address_length;
> -        addr->maximum = addr->minimum + addr->address_length - 1;
> -        return AE_OK;
> -    case ACPI_RESOURCE_TYPE_MEMORY32:
> -        memory32 = &resource->data.memory32;
> -        addr->resource_type = ACPI_MEMORY_RANGE;
> -        addr->minimum = memory32->minimum;
> -        addr->address_length = memory32->address_length;
> -        addr->maximum = addr->minimum + addr->address_length - 1;
> -        return AE_OK;
> -    case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
> -        fixed_memory32 = &resource->data.fixed_memory32;
> -        addr->resource_type = ACPI_MEMORY_RANGE;
> -        addr->minimum = fixed_memory32->address;
> -        addr->address_length = fixed_memory32->address_length;
> -        addr->maximum = addr->minimum + addr->address_length - 1;
> -        return AE_OK;
> -    case ACPI_RESOURCE_TYPE_ADDRESS16:
> -    case ACPI_RESOURCE_TYPE_ADDRESS32:
> -    case ACPI_RESOURCE_TYPE_ADDRESS64:
> -        status = acpi_resource_to_address64(resource, addr);
> -        if (ACPI_SUCCESS(status) &&
> -            (addr->resource_type == ACPI_MEMORY_RANGE ||
> -            addr->resource_type == ACPI_IO_RANGE) &&
> -            addr->address_length > 0) {
> -            return AE_OK;
> -        }
> -        break;
> -    }
> -    return AE_ERROR;
> -}
> -
> -static acpi_status
>  count_resource(struct acpi_resource *acpi_res, void *data)
>  {
>      struct pci_root_info *info = data;
> -    struct acpi_resource_address64 addr;
> -    acpi_status status;
> +    struct resource res;
>
> -    status = resource_to_addr(acpi_res, &addr);
> -    if (ACPI_SUCCESS(status))
> +    if (acpi_dev_resource_address_space(acpi_res, &res)
> +        || acpi_dev_resource_memory(acpi_res, &res))
>          info->res_num++;
> +
>      return AE_OK;
>  }
>
> @@ -282,27 +235,18 @@ static acpi_status
>  setup_resource(struct acpi_resource *acpi_res, void *data)
>  {
>      struct pci_root_info *info = data;
> -    struct resource *res;
> +    struct resource *res = &info->res[info->res_num];
>      struct acpi_resource_address64 addr;
> -    acpi_status status;
> -    unsigned long flags;
>      u64 start, orig_end, end;
>
> -    status = resource_to_addr(acpi_res, &addr);
> -    if (!ACPI_SUCCESS(status))
> -        return AE_OK;
> +    memset(&addr, 0x00, sizeof(addr));
>
> -    if (addr.resource_type == ACPI_MEMORY_RANGE) {
> -        flags = IORESOURCE_MEM;
> -        if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
> -            flags |= IORESOURCE_PREFETCH;
> -    } else if (addr.resource_type == ACPI_IO_RANGE) {
> -        flags = IORESOURCE_IO;
> -    } else
> +    if (!(acpi_dev_resource_address_space_with_addr(acpi_res, &addr, res)
> +        || acpi_dev_resource_memory(acpi_res, res)))

acpi_dev_resource_address_space_with_addr(acpi_res, &addr, res)

passing extra addr, just for translation_offset?

maybe pass res_offset directly?




>          return AE_OK;
>
> -    start = addr.minimum + addr.translation_offset;
> -    orig_end = end = addr.maximum + addr.translation_offset;
> +    start = res->start;
> +    orig_end = end = res->end;

Yinghai
