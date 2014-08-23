Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaHWE13 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 00:27:29 -0400
Received: from [207.46.163.208] ([207.46.163.208]:21825 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752152AbaHWE12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 00:27:28 -0400
Message-ID: <53F817F6.2060503@freescale.com>
Date: Fri, 22 Aug 2014 23:26:30 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <stuart.yoder@freescale.com>, <linuxppc-release@linux.freescale.net>
Subject: Re: [RFC PATCH 2/4] drivers/bus: Freescale Management Complex (fsl-mc)
 bus driver
References: <1408140794-25064-1-git-send-email-German.Rivera@freescale.com> <3344352.Av1d0tahxM@wuerfel> <53F3B8EA.6070609@freescale.com> <201408211330.20869.arnd@arndb.de>
In-Reply-To: <201408211330.20869.arnd@arndb.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.49]
X-ClientProxiedBy: BN1PR08CA0041.namprd08.prod.outlook.com (10.242.217.169) To
 BY2PR03MB332.namprd03.prod.outlook.com (10.141.139.23)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6049001)(6009001)(377454003)(24454002)(479174003)(164054003)(51704005)(199003)(189002)(92726001)(85306004)(74502001)(59896002)(64706001)(76176999)(65806001)(85852003)(87266999)(65816999)(50986999)(99396002)(80022001)(42186005)(83322001)(101416001)(81542001)(33656002)(87976001)(80316001)(47776003)(31966008)(77982001)(92566001)(102836001)(74662001)(106356001)(83072002)(46102001)(105586002)(76482001)(21056001)(81342001)(86362001)(107046002)(54356999)(50466002)(93886004)(95666004)(23746002)(110136001)(66066001)(36756003)(79102001)(4396001)(77096002)(90102001)(65956001)(20776003)(83506001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB332;H:[10.214.84.182];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

I have posted respin v3 of this patch series to address your lastest  of 
comments. Please see below the resolutions.

Thanks,

German

On 08/21/2014 06:30 AM, Arnd Bergmann wrote:
> On Tuesday 19 August 2014, German Rivera wrote:
>>>> + * @dev_node: Node in the container's child list
>>>
>>> Same here: just use the device model's list management instead if you can,
>>> or explain why this is needed.
>>>
>> We still need to keep a per-bus list of child devices (devices contained
>> in a given DPRC object). Unless I'm missing something,
>> I think the device model's list management links together all the
>> devices of the same bus type. We are trying to follow a similar approach
>> to the pci_dev/pci_bus structs.
>
> There are multiple lists in the device handling. device_for_each_child()
> should iterate over the children of a particular device using the
> klist_children member.
>
Removed per-bus list of children, and instead use 
device_for_each_child() as you suggested.

>>>> +/**
>>>> + * struct fsl_mc_dprc - Data Path Resource Container (DPRC) object
>>>> + * @magic: marker to verify identity of this structure
>>>> + * @mc_dev: pointer to MC object device object for this DPRC
>>>> + * @mutex: mutex to serialize access to the container.
>>>> + * @child_device_count: have the count of devices in this DPRC
>>>> + * @child_list:     anchor node of list of child devices on this DPRC
>>>> + */
>>>> +struct fsl_mc_dprc {
>>>> +#   define FSL_MC_DPRC_MAGIC   FSL_MC_MAGIC('D', 'P', 'R', 'C')
>>>> +    uint32_t magic;
>>>> +    struct fsl_mc_device *mc_dev;
>>>> +    struct mutex mutex;     /* serializes access to fields below */
>>>> +    uint16_t child_device_count;    /* Count of devices in this DPRC */
>>>> +    struct list_head child_list;
>>>> +};
>>>
>>> It's not clear what this represents to me. mc_dev presumably already
>>> has a list of children, so why not just use a pointer to mc_dev
>>> and remove this structure entirely?
>>>
>> This structure represents the per-bus (per DPRC object) information.
>> It is kind of the equivalent to 'struct pci_bus' in the PCI world.
>> I have renamed this struct to 'struct fsl_mc_bus'.
>
> Ok, I'll look at the new version when I get back to Germany. I still think
> that can remove all members of the current structure and just use the
> same structure for fsl_mc_bus and fsl_mc_device. If you really need
> a small number of extra members beyond what is in the device, you have
> two other choices:
>
By removing the child list from the fsl_mc_bus structure as you 
suggested, the fsl_mc_bus structure does not need to exist for this 
patch series. As you rightfully suggested, we can use just one
structure (fsl_mc_device) to represent both regular devices (children)
and bus devices.

> a) put the members into the device structure as well but not use them
>     for a device that is not a bus
>
> b) embed the device structure within the bus structure like
>
> 	struct fsl_mc_bus {
> 		int something;
> 		struct fsl_mc_device;
> 	};
>
> and then use container_of() to go from the device to the bus where needed
> rather than having two objects that are allocated separately. This is
> what a lot of other subsystems (not PCI) do. See for instance
> platform_device, which often has child devices as well.
>
In other functionality to be delivered as a follow-on patch series
(after this patch series), we will need to track some per-bus 
information, and we will do so using your "b)" recommendation.

> 	Arnd
>
