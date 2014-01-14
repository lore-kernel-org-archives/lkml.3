Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaANPBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:01:39 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:10705 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaANPBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:01:34 -0500
Message-ID: <52D5514A.8010609@atmel.com>
Date: Tue, 14 Jan 2014 16:01:30 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        boris brezillon <b.brezillon@overkiz.com>
CC: <plagnioj@jcrosoft.com>, <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/12] at91: dt: smc: Added smc bus driver
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>	<1389270709-32662-8-git-send-email-jjhiblot@traphandler.com>	<52CED586.7030602@overkiz.com>	<CACh+v5MvJptBsEcdmcDRTBZ1rKbt-iWKEQUpiME382B0qePC3A@mail.gmail.com>	<52D0FB78.6010102@overkiz.com> <CACh+v5MWNXyGfj=uS0Z9RpCZTJ=nqY1WzBpv9L-8608n_iy6zQ@mail.gmail.com>
In-Reply-To: <CACh+v5MWNXyGfj=uS0Z9RpCZTJ=nqY1WzBpv9L-8608n_iy6zQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/2014 15:20, Jean-Jacques Hiblot :
> 2014/1/11 boris brezillon <b.brezillon@overkiz.com>:
>> On 09/01/2014 22:04, Jean-Jacques Hiblot wrote:
>>>
>>> Hi Boris,
>>>
>>> 2014/1/9 boris brezillon <b.brezillon@overkiz.com>:
>>>>
>>>> Hello JJ,
>>>>
>>>>
>>>> On 09/01/2014 13:31, Jean-Jacques Hiblot wrote:
>>>>>
>>>>> The EBI/SMC external interface is used to access external peripherals
>>>>> (NAND
>>>>> and Ethernet controller in the case of sam9261ek). Different
>>>>> configurations and
>>>>> timings are required for those peripherals. This bus driver can be used
>>>>> to
>>>>> setup the bus timings/configuration from the device tree.
>>>>> It currently accepts timings in clock period and in nanoseconds.
>>>>>
>>>>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>>>>> ---
>>>>>    drivers/memory/Kconfig     |  10 ++
>>>>>    drivers/memory/Makefile    |   1 +
>>>>>    drivers/memory/atmel-smc.c | 431
>>>>> +++++++++++++++++++++++++++++++++++++++++++++
>>>>>    3 files changed, 442 insertions(+)
>>>>>    create mode 100644 drivers/memory/atmel-smc.c
>>>>>
>>>>> diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
>>>>> index 29a11db..fbdfd63 100644
>>>>> --- a/drivers/memory/Kconfig
>>>>> +++ b/drivers/memory/Kconfig
>>>>> @@ -50,4 +50,14 @@ config TEGRA30_MC
>>>>>            analysis, especially for IOMMU/SMMU(System Memory Management
>>>>>            Unit) module.
>>>>>    +config ATMEL_SMC
>>>>> +       bool "Atmel SMC/EBI driver"
>>>>> +       default y
>>>>> +       depends on SOC_AT91SAM9 && OF
>>>>> +       help
>>>>> +         Driver for Atmel SMC/EBI controller.
>>>>> +         Used to configure the EBI (external bus interface) when the
>>>>> device-
>>>>> +         tree is used. This bus supports NANDs, external ethernet
>>>>> controller,
>>>>> +         SRAMs, ATA devices, etc.
>>>>> +
>>>>>    endif
>>>>> diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
>>>>> index 969d923..101abc4 100644
>>>>> --- a/drivers/memory/Makefile
>>>>> +++ b/drivers/memory/Makefile
>>>>> @@ -9,3 +9,4 @@ obj-$(CONFIG_TI_EMIF)           += emif.o
>>>>>    obj-$(CONFIG_MVEBU_DEVBUS)    += mvebu-devbus.o
>>>>>    obj-$(CONFIG_TEGRA20_MC)      += tegra20-mc.o
>>>>>    obj-$(CONFIG_TEGRA30_MC)      += tegra30-mc.o
>>>>> +obj-$(CONFIG_ATMEL_SMC)        += atmel-smc.o
>>>>> diff --git a/drivers/memory/atmel-smc.c b/drivers/memory/atmel-smc.c
>>>>> new file mode 100644
>>>>> index 0000000..0a1d9ba
>>>>> --- /dev/null
>>>>> +++ b/drivers/memory/atmel-smc.c
>>>>> @@ -0,0 +1,431 @@
>>>>> +/*
>>>>> + * EBI driver for Atmel SAM9 chips
>>>>> + * inspired by the fsl weim bus driver
>>>>> + *
>>>>> + * Copyright (C) 2013 JJ Hiblot.
>>>>> + *
>>>>> + * This file is licensed under the terms of the GNU General Public
>>>>> + * License version 2. This program is licensed "as is" without any
>>>>> + * warranty of any kind, whether express or implied.
>>>>> + */
>>>>> +#include <linux/module.h>
>>>>> +#include <linux/clk.h>
>>>>> +#include <linux/io.h>
>>>>> +#include <linux/of_device.h>
>>>>> +#include <mach/at91sam9_smc.h>
>>>>
>>>>
>>>> You should avoid machine specific headers inclusions: we're trying to get
>>>> rid of them.
>>>>
>>>> Duplicate the code and macros you need in your driver instead.
>>>
>>> Is this the right way?
>>
>> Not necessarily. But in any case you should not reference machine specific
>> headers in new drivers, because the ARM architecture maintainers are
>> trying to get all architecture specific code moved into regular subsystems.
>>
>> There surely is a lot of pros to this approach (I'll let others detail
>> these).
>> The main one I see is that the subsystem maintainer is then able to track
>> common designs in all available drivers and provide a common framework
>> in order to :
>> 1) ease other drivers development
>> 2) avoid code duplication
>>
>> In your case, this leaves 2 solutions:
>> 1) move the sam9_smc fonctions in the new driver and move the sam9_smc
>>     into include/linux/memory (which apparently does not exist).
>> 2) copy all the functions and definition you need in your driver in order to
>> get
>>     rid of the old implementation, and choose which one to compile using
>> Kconfig
>>     options.
>>
>> If you think the sam9_smc existing implementation already match your new
>> driver
>> needs, I strongly recommend choosing solution 1, as it will help smoothly
>> move to your
>> new driver without having to modify already existing drivers using sam9_smc
>> functions
>> (except for the new header path ;)).
>>
> I agree. Merging the code of arch/arm/mach-at91/sam9_smc.c into this
> new driver makes sense.
> Nicolas, Jean-Christophe, what is the stand point of the atmel's
> maintainers on this ?

I do agree with solution 1.
We will need to pay attention to the path modification on other files
but the benefit of having a SMC driver and the move of code out of the
mach-at91 directory definitively worth it.

Thanks for you work Jean-Jacques.

Bye,

>>> We usually try to avoid duplication.
>>
>>>
>>>>
>>>>> +
>>>>> +struct  smc_data {
>>>>> +       struct clk *bus_clk;
>>>>> +       void __iomem *base;
>>>>> +       struct device *dev;
>>>>> +};
>>>>> +
>>>>> +struct at91_smc_devtype {
>>>>> +       unsigned int    cs_count;
>>>>> +};
>>>>> +
>>>>> +static const struct at91_smc_devtype sam9261_smc_devtype = {
>>>>> +       .cs_count       = 6,
>>>>> +};
>>>>> +
>>>>> +static const struct of_device_id smc_id_table[] = {
>>>>> +       { .compatible = "atmel,at91sam9261-smc", .data =
>>>>> &sam9261_smc_devtype},
>>>>> +       { }
>>>>> +};
>>>>> +MODULE_DEVICE_TABLE(of, smc_id_table);
>>>>> +
>>>>> +struct smc_parameters_type {
>>>>> +       const char *name;
>>>>> +       u16 width;
>>>>> +       u16 shift;
>>>>> +};
>>>>> +
>>>>> +static const struct smc_parameters_type smc_parameters[] = {
>>>>> +       {"smc,burst_size",      2, 28},
>>>>> +       {"smc,burst_enabled",   1, 24},
>>>>> +       {"smc,tdf_mode",        1, 20},
>>>>> +       {"smc,bus_width",       2, 12},
>>>>> +       {"smc,byte_access_type", 1,  8},
>>>>> +       {"smc,nwait_mode",      2,  4},
>>>>> +       {"smc,write_mode",      1,  0},
>>>>> +       {"smc,read_mode",       1,  1},
>>>>> +       {NULL}
>>>>> +};
>>>>> +
>>>>> +static int get_mode_register_from_dt(struct smc_data *smc,
>>>>> +                                    struct device_node *np,
>>>>> +                                    struct sam9_smc_config *cfg)
>>>>> +{
>>>>> +       int ret;
>>>>> +       u32 val;
>>>>> +       struct device *dev = smc->dev;
>>>>> +       const struct smc_parameters_type *p = smc_parameters;
>>>>> +       u32 mode = cfg->mode;
>>>>> +
>>>>> +       while (p->name) {
>>>>> +               ret = of_property_read_u32(np, p->name , &val);
>>>>> +               if (ret == -EINVAL) {
>>>>> +                       dev_dbg(dev, "%s: property %s not set.\n",
>>>>> np->name,
>>>>> +                               p->name);
>>>>> +                       p++;
>>>>> +                       continue;
>>>>> +               } else if (ret) {
>>>>> +                       dev_err(dev, "%s: can't get property %s.\n",
>>>>> np->name,
>>>>> +                               p->name);
>>>>> +                       return ret;
>>>>> +               }
>>>>> +               if (val >= (1<<p->width)) {
>>>>> +                       dev_err(dev, "%s: property %s out of range.\n",
>>>>> +                               np->name, p->name);
>>>>> +                       return -ERANGE;
>>>>> +               }
>>>>> +               mode &= ~(((1<<p->width)-1) << p->shift);
>>>>> +               mode |= (val << p->shift);
>>>>> +               p++;
>>>>> +       }
>>>>> +       cfg->mode = mode;
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>> +static int generic_timing_from_dt(struct smc_data *smc, struct
>>>>> device_node *np,
>>>>> +                                 struct sam9_smc_config *cfg)
>>>>> +{
>>>>> +       u32 val;
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,ncs_read_setup" , &val))
>>>>> +               cfg->ncs_read_setup = val;
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,nrd_setup" , &val))
>>>>> +               cfg->nrd_setup = val;
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,ncs_write_setup" , &val))
>>>>> +               cfg->ncs_write_setup = val;
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,nwe_setup" , &val))
>>>>> +               cfg->nwe_setup = val;
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,ncs_read_pulse" , &val))
>>>>> +               cfg->ncs_read_pulse = val;
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,nrd_pulse" , &val))
>>>>> +               cfg->nrd_pulse = val;
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,ncs_write_pulse" , &val))
>>>>> +               cfg->ncs_write_pulse = val;
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,nwe_pulse" , &val))
>>>>> +               cfg->nwe_pulse = val;
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,read_cycle" , &val))
>>>>> +               cfg->read_cycle = val;
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,write_cycle" , &val))
>>>>> +               cfg->write_cycle = val;
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,tdf_cycles" , &val))
>>>>> +               cfg->tdf_cycles = val;
>>>>> +
>>>>> +       return get_mode_register_from_dt(smc, np, cfg);
>>>>> +}
>>>>> +
>>>>> +/* convert the time in ns in a number of clock cycles */
>>>>> +static u32 ns_to_cycles(u32 ns, u32 clk)
>>>>> +{
>>>>> +       /*
>>>>> +        * convert the clk to kHz for the rest of the calculation to
>>>>> avoid
>>>>> +        * overflow
>>>>> +        */
>>>>> +       u32 clk_kHz = clk / 1000;
>>>>> +       u32 ncycles = ((ns * clk_kHz) + 1000000 - 1) / 1000000;
>>>>
>>>> What about using an u64 type and do_div ?
>>>
>>> easier and faster (though it's not the point here) this way, and kHz
>>> ist not so imprecise :-)
>>>
>>>>> +       return ncycles;
>>>>> +}
>>>>> +
>>>>> +static u32 cycles_to_coded_cycle(u32 cycles, int a, int b)
>>>>> +{
>>>>> +       u32 mask_high = (1 << a) - 1;
>>>>> +       u32 mask_low = (1 << b) - 1;
>>>>> +       u32 coded;
>>>>> +
>>>>> +       /* check if the value can be described with the coded format */
>>>>> +       if (cycles & (mask_high & ~mask_low)) {
>>>>> +               /* not representable. we need to round up */
>>>>> +               cycles |= mask_high;
>>>>> +               cycles += 1;
>>>>> +       }
>>>>> +       /* Now the value can be represented in the coded format */
>>>>> +       coded = (cycles & ~mask_high) >> (a - b);
>>>>> +       coded |= (cycles & mask_low);
>>>>> +       return coded;
>>>>> +}
>>>>> +
>>>>> +static u32 ns_to_rw_cycles(u32 ns, u32 clk)
>>>>> +{
>>>>> +       return cycles_to_coded_cycle(ns_to_cycles(ns, clk), 8, 7);
>>>>> +}
>>>>> +
>>>>> +static u32 ns_to_pulse_cycles(u32 ns, u32 clk)
>>>>> +{
>>>>> +       return cycles_to_coded_cycle(ns_to_cycles(ns, clk), 8, 6);
>>>>> +}
>>>>> +
>>>>> +static u32 ns_to_setup_cycles(u32 ns, u32 clk)
>>>>> +{
>>>>> +       return cycles_to_coded_cycle(ns_to_cycles(ns, clk), 7, 5);
>>>>> +}
>>>>> +
>>>>> +static u32 cycles_to_ns(u32 cycles, u32 clk)
>>>>> +{
>>>>> +       /*
>>>>> +        * convert the clk to kHz for the rest of the calculation to
>>>>> avoid
>>>>> +        * overflow
>>>>> +        */
>>>>> +       u32 clk_kHz = clk / 1000;
>>>>
>>>>
>>>> Ditto (u64 + do_div).
>>>>
>>>>> +       return (cycles * 1000000) / clk_kHz;
>>>>> +}
>>>>> +
>>>>> +static u32 coded_cycle_to_cycles(u32 coded, int a, int b)
>>>>> +{
>>>>> +       u32 cycles = (coded >> b) << a;
>>>>> +       u32 mask_low = (1 << b) - 1;
>>>>> +       cycles |= (coded & mask_low);
>>>>> +       return cycles;
>>>>> +}
>>>>> +
>>>>> +static u32 rw_cycles_to_ns(u32 reg, u32 clk)
>>>>> +{
>>>>> +       return cycles_to_ns(coded_cycle_to_cycles(reg, 8, 7), clk);
>>>>> +}
>>>>> +
>>>>> +static u32 pulse_cycles_to_ns(u32 reg, u32 clk)
>>>>> +{
>>>>> +       return cycles_to_ns(coded_cycle_to_cycles(reg, 8, 6), clk);
>>>>> +}
>>>>> +
>>>>> +static u32 setup_cycles_to_ns(u32 reg, u32 clk)
>>>>> +{
>>>>> +       return cycles_to_ns(coded_cycle_to_cycles(reg, 7, 5), clk);
>>>>> +}
>>>>> +
>>>>> +static void dump_timing(struct smc_data *smc, struct sam9_smc_config
>>>>> *config)
>>>>> +{
>>>>> +       u32 freq = clk_get_rate(smc->bus_clk);
>>>>> +       struct device *dev = smc->dev;
>>>>> +
>>>>> +#define DUMP(fn, y)    dev_info(dev, "%s : 0x%x (%d ns)\n", #y,
>>>>> config->y,\
>>>>> +                                fn(config->y, freq))
>>>>> +#define DUMP_PULSE(y)  DUMP(pulse_cycles_to_ns, y)
>>>>> +#define DUMP_RWCYCLE(y)        DUMP(rw_cycles_to_ns, y)
>>>>> +#define DUMP_SETUP(y)  DUMP(setup_cycles_to_ns, y)
>>>>> +#define DUMP_SIMPLE(y) DUMP(cycles_to_ns, y)
>>>>> +
>>>>> +       DUMP_SETUP(nwe_setup);
>>>>> +       DUMP_SETUP(ncs_write_setup);
>>>>> +       DUMP_SETUP(nrd_setup);
>>>>> +       DUMP_SETUP(ncs_read_setup);
>>>>> +       DUMP_PULSE(nwe_pulse);
>>>>> +       DUMP_PULSE(ncs_write_pulse);
>>>>> +       DUMP_PULSE(nrd_pulse);
>>>>> +       DUMP_PULSE(ncs_read_pulse);
>>>>> +       DUMP_RWCYCLE(write_cycle);
>>>>> +       DUMP_RWCYCLE(read_cycle);
>>>>> +       DUMP_SIMPLE(tdf_cycles);
>>>>> +}
>>>>> +
>>>>> +static int ns_timing_from_dt(struct smc_data *smc, struct device_node
>>>>> *np,
>>>>> +                            struct sam9_smc_config *cfg)
>>>>> +{
>>>>> +       u32 t_ns;
>>>>> +       u32 freq = clk_get_rate(smc->bus_clk);
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,ncs_read_setup" , &t_ns))
>>>>> +               cfg->ncs_read_setup = ns_to_setup_cycles(t_ns, freq);
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,nrd_setup" , &t_ns))
>>>>> +               cfg->nrd_setup = ns_to_setup_cycles(t_ns, freq);
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,ncs_write_setup" , &t_ns))
>>>>> +               cfg->ncs_write_setup = ns_to_setup_cycles(t_ns, freq);
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,nwe_setup" , &t_ns))
>>>>> +               cfg->nwe_setup = ns_to_setup_cycles(t_ns, freq);
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,ncs_read_pulse" , &t_ns))
>>>>> +               cfg->ncs_read_pulse = ns_to_pulse_cycles(t_ns, freq);
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,nrd_pulse" , &t_ns))
>>>>> +               cfg->nrd_pulse = ns_to_pulse_cycles(t_ns, freq);
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,ncs_write_pulse" , &t_ns))
>>>>> +               cfg->ncs_write_pulse = ns_to_pulse_cycles(t_ns, freq);
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,nwe_pulse" , &t_ns))
>>>>> +               cfg->nwe_pulse = ns_to_pulse_cycles(t_ns, freq);
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,read_cycle" , &t_ns))
>>>>> +               cfg->read_cycle = ns_to_rw_cycles(t_ns, freq);
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,write_cycle" , &t_ns))
>>>>> +               cfg->write_cycle = ns_to_rw_cycles(t_ns, freq);
>>>>> +
>>>>> +       if (!of_property_read_u32(np, "smc,tdf_cycles" , &t_ns))
>>>>> +               cfg->tdf_cycles = ns_to_cycles(t_ns, freq);
>>>>> +
>>>>> +       return get_mode_register_from_dt(smc, np, cfg);
>>>>> +}
>>>>> +
>>>>> +struct converter {
>>>>> +       const char *name;
>>>>> +       int (*fn) (struct smc_data *smc, struct device_node *np,
>>>>> +                  struct sam9_smc_config *cfg);
>>>>> +};
>>>>> +static const struct converter converters[] = {
>>>>> +       {"raw", generic_timing_from_dt},
>>>>> +       {"nanosec", ns_timing_from_dt},
>>>>> +};
>>>>
>>>>
>>>> Could you use more specific names like:
>>>> "atmel,smc-converter-generic"
>>>> "atmel,smc-converter-nand"
>>>> ...
>>>
>>> Isn't it a bit redudant? smc,converter = "atmel,smc-converter-generic";
>>>
>>>> IMHO the timing unit should be specified in the property names:
>>>> smc,ncs_read_setup-ns
>>>> smc,ncs_read_setup-cycles
>>>>
>>> True. Although cycles is misleading. It's more a raw register value.
>>> For pulse, setup and rw cycle, the register value is not identical to
>>> the number of cycles.
>>>>
>>>>
>>>>
>>>>> +
>>>>> +/* Parse and set the timing for this device. */
>>>>> +static int smc_timing_setup(struct smc_data *smc, struct device_node
>>>>> *np,
>>>>> +               const struct at91_smc_devtype *devtype)
>>>>> +{
>>>>> +       int ret;
>>>>> +       u32 cs;
>>>>> +       int i;
>>>>> +       struct device *dev = smc->dev;
>>>>> +       const struct converter *converter;
>>>>> +       const char *converter_name = NULL;
>>>>> +       struct sam9_smc_config cfg;
>>>>> +
>>>>> +       ret = of_property_read_u32(np, "smc,cs" , &cs);
>>>>
>>>>
>>>> Shouldn't this be stored in the reg property ?
>>>> After all, in your DM9000 patch you use "@cs,offset" to identify the
>>>> node...
>>>
>>> True
>>>
>>>>
>>>>> +       if (ret < 0) {
>>>>> +               dev_err(dev, "missing mandatory property : smc,cs\n");
>>>>> +               return ret;
>>>>> +       }
>>>>> +       if (cs >= devtype->cs_count) {
>>>>> +               dev_err(dev, "invalid value for property smc,cs (=%d)."
>>>>> +               "Must be in range 0 to %d\n", cs, devtype->cs_count-1);
>>>>> +               return -EINVAL;
>>>>> +       }
>>>>> +
>>>>> +       of_property_read_string(np, "smc,converter", &converter_name);
>>>>
>>>>
>>>> What about using the "compatible" property + struct of_device_id instead
>>>> of
>>>> "smc,converter" property + struct converter ?
>>>
>>> Because one instance of the driver handles several chip selects and
>>> each may use a different converter.
>>>
>>>>
>>>>> +       if (converter_name) {
>>>>> +               for (i = 0; i < ARRAY_SIZE(converters); i++)
>>>>> +                       if (strcmp(converters[i].name, converter_name)
>>>>> ==
>>>>> 0)
>>>>> +                               converter = &converters[i];
>>>>> +               if (!converter) {
>>>>> +                       dev_info(dev, "unknown converter. aborting\n");
>>>>> +                       return -EINVAL;
>>>>> +               }
>>>>> +       } else {
>>>>> +               dev_dbg(dev, "cs %d: no smc converter provided. using "
>>>>> +               "raw register values\n", cs);
>>>>> +               converter = &converters[0];
>>>>> +       }
>>>>> +       dev_dbg(dev, "cs %d using converter : %s\n", cs,
>>>>> converter->name);
>>>>> +       sam9_smc_cs_read(smc->base + (0x10 * cs), &cfg);
>>>>> +       converter->fn(smc, np, &cfg);
>>>>> +       ret = sam9_smc_check_cs_configuration(&cfg);
>>>>> +       if (ret < 0) {
>>>>> +               dev_info(dev, "invalid smc configuration for cs %d."
>>>>> +               "clipping values\n", cs);
>>>>> +               sam9_smc_clip_cs_configuration(&cfg);
>>>>> +               dump_timing(smc, &cfg);
>>>>> +       }
>>>>> +#ifdef DEBUG
>>>>> +       else
>>>>> +               dump_timing(smc, &cfg);
>>>>> +#endif
>>>>
>>>>
>>>> I'm not a big fan of #ifdef blocks inside the code.
>>>> You could define a dummy dump_timing function if DEBUG is not defined:
>>>>
>>>> #ifdef DEBUG
>>>>
>>>>
>>>> static void dump_timing(struct smc_data *smc, struct sam9_smc_config
>>>> *config)
>>>> {
>>>>      /* your implementation */
>>>> }
>>>>
>>>> #else
>>>>
>>>> static inline void dump_timing(struct smc_data *smc, struct
>>>> sam9_smc_config
>>>> *config)
>>>> {
>>>> }
>>>>
>>>> #endif
>>>>
>>>> Or just use dev_dbg when printing things in dump_timing.
>>>>
>>> I wanted to know the values when they were modified (clipped) by the
>>> driver. But it could be removed, knowing that clipping occurred is
>>> enough.
>>>>
>>>>
>>>>> +
>>>>> +       sam9_smc_cs_configure(smc->base + (0x10 * cs), &cfg);
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>> +static int smc_parse_dt(struct smc_data *smc)
>>>>> +{
>>>>> +       struct device *dev = smc->dev;
>>>>> +       const struct of_device_id *of_id = of_match_device(smc_id_table,
>>>>> dev);
>>>>> +       const struct at91_smc_devtype *devtype = of_id->data;
>>>>> +       struct device_node *child;
>>>>> +       int ret;
>>>>> +
>>>>> +       for_each_child_of_node(dev->of_node, child) {
>>>>> +               if (!child->name)
>>>>> +                       continue;
>>>>> +               if (!of_device_is_available(child))
>>>>> +                       continue;
>>>>> +               ret = smc_timing_setup(smc, child, devtype);
>>>>> +               if (ret) {
>>>>> +                       static struct property status = {
>>>>> +                               .name = "status",
>>>>> +                               .value = "disabled",
>>>>> +                               .length = sizeof("disabled"),
>>>>> +                       };
>>>>> +                       dev_err(dev, "%s set timing failed. This node
>>>>> will
>>>>> be disabled.\n",
>>>>> +                               child->full_name);
>>>>> +                       ret = of_update_property(child, &status);
>>>>> +                       if (ret < 0) {
>>>>> +                               dev_err(dev, "can't disable %s. aborting
>>>>> probe\n",
>>>>> +                               child->full_name);
>>>>> +                               break;
>>>>
>>>>
>>>> The concept of disabling the device if timings cannot be met sounds
>>>> interresting...
>>>> Let's see what other maintainers say about this :).
>>>>
>>>>
>>>>> +                       }
>>>>> +               }
>>>>> +       }
>>>>> +
>>>>> +       ret = of_platform_populate(dev->of_node,
>>>>> of_default_bus_match_table,
>>>>> +                                  NULL, dev);
>>>>> +       if (ret)
>>>>> +               dev_err(dev, "%s fail to create devices.\n",
>>>>> +                       dev->of_node->full_name);
>>>>> +
>>>>> +       return ret;
>>>>> +}
>>>>> +
>>>>> +static int smc_probe(struct platform_device *pdev)
>>>>> +{
>>>>> +       struct resource *res;
>>>>> +       int ret;
>>>>> +       void __iomem *base;
>>>>> +       struct clk *clk;
>>>>> +       struct smc_data *smc = devm_kzalloc(&pdev->dev, sizeof(struct
>>>>> smc_data),
>>>>> +                                           GFP_KERNEL);
>>>>> +
>>>>> +       if (!smc)
>>>>> +               return -ENOMEM;
>>>>> +
>>>>> +       smc->dev = &pdev->dev;
>>>>> +
>>>>> +       /* get the resource */
>>>>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>>> +       base = devm_request_and_ioremap(&pdev->dev, res);
>>>>> +       if (IS_ERR(base)) {
>>>>> +               dev_err(&pdev->dev, "can't map SMC base address\n");
>>>>> +               return PTR_ERR(base);
>>>>> +       }
>>>>> +
>>>>> +       /* get the clock */
>>>>> +       clk = devm_clk_get(&pdev->dev, "smc");
>>>>> +       if (IS_ERR(clk))
>>>>> +               return PTR_ERR(clk);
>>>>> +
>>>>> +       smc->bus_clk = clk;
>>>>> +       smc->base = base;
>>>>> +
>>>>> +       /* parse the device node */
>>>>> +       ret = smc_parse_dt(smc);
>>>>> +       if (!ret)
>>>>> +               dev_info(&pdev->dev, "Driver registered.\n");
>>>>> +
>>>>> +       return ret;
>>>>> +}
>>>>> +
>>>>> +static struct platform_driver smc_driver = {
>>>>> +       .driver = {
>>>>> +               .name           = "atmel-smc",
>>>>> +               .owner          = THIS_MODULE,
>>>>> +               .of_match_table = smc_id_table,
>>>>> +       },
>>>>> +};
>>>>> +module_platform_driver_probe(smc_driver, smc_probe);
>>>>> +
>>>>> +MODULE_AUTHOR("JJ Hiblot");
>>>>> +MODULE_DESCRIPTION("Atmel's SMC/EBI driver");
>>>>> +MODULE_LICENSE("GPL");
>>>>
>>>>
>>>>
>>>> That's all for now. :)
>>>>
>>>> I'll try to test it this week end on a sama5 board.
>>>
>>> Thanks
>>>
>>>> Best Regards,
>>>>
>>>> Boris
>>
>>
> 
> 


-- 
Nicolas Ferre
