Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaIYPpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:45:05 -0400
Received: from mail-bn1bon0118.outbound.protection.outlook.com ([157.56.111.118]:59716
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752600AbaIYPpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:45:03 -0400
Message-ID: <54243873.9060509@freescale.com>
Date: Thu, 25 Sep 2014 10:44:51 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>,
        Erez Nir-RM30794 <nir.erez@freescale.com>
Subject: Re: [PATCH 1/3 v2] drivers/bus: Added Freescale Management Complex
 APIs
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>	<1411166981-3610-2-git-send-email-German.Rivera@freescale.com>	<20140923194901.894483bfaef97d13d12c75a5@freescale.com>	<54237CBF.2010706@freescale.com> <20140924224006.f924cefdd347464519da8190@freescale.com>
In-Reply-To: <20140924224006.f924cefdd347464519da8190@freescale.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: DM2PR04CA024.namprd04.prod.outlook.com (10.141.154.142) To
 BLUPR03MB328.namprd03.prod.outlook.com (10.141.48.27)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB328;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(377454003)(479174003)(24454002)(164054003)(199003)(51704005)(189002)(87976001)(83506001)(47776003)(107046002)(20776003)(93886004)(19580395003)(19580405001)(81342003)(83322001)(46102003)(77982003)(42186005)(101416001)(99396003)(85306004)(65956001)(65806001)(120916001)(83072002)(102836001)(66066001)(76482002)(10300001)(64706001)(77096002)(95666004)(85852003)(105586002)(50466002)(106356001)(4396001)(110136001)(21056001)(64126003)(97736003)(31966008)(50986999)(87266999)(65816999)(79102003)(76176999)(23676002)(74662003)(81542003)(74502003)(54356999)(80022003)(36756003)(92566001)(92726001)(86362001)(117636001)(99136001)(90102001)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB328;H:[10.214.84.145];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/24/2014 10:40 PM, Kim Phillips wrote:
> On Wed, 24 Sep 2014 21:23:59 -0500
> German Rivera <German.Rivera@freescale.com> wrote:
>
>> On 09/23/2014 07:49 PM, Kim Phillips wrote:
>>> On Fri, 19 Sep 2014 17:49:39 -0500
>>> "J. German Rivera" <German.Rivera@freescale.com> wrote:
>>>
>>>> + * Delay in microseconds between polling iterations while
>>>> + * waiting for MC command completion
>>>> + */
>>>> +#define MC_CMD_COMPLETION_POLLING_INTERVAL_USECS    500	/* 0.5 ms */
>>>> +
>>>> +int __must_check fsl_create_mc_io(struct device *dev,
>>>> +				  phys_addr_t mc_portal_phys_addr,
>>>> +				  uint32_t mc_portal_size,
>>>> +				  uint32_t flags, struct fsl_mc_io **new_mc_io)
>>>> +{
>>>> +	struct fsl_mc_io *mc_io;
>>>> +	void __iomem *mc_portal_virt_addr;
>>>> +	struct resource *res;
>>>> +
>>>> +	mc_io = devm_kzalloc(dev, sizeof(*mc_io), GFP_KERNEL);
>>>> +	if (mc_io == NULL)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	mc_io->dev = dev;
>>>> +	mc_io->flags = flags;
>>>> +	mc_io->portal_phys_addr = mc_portal_phys_addr;
>>>> +	mc_io->portal_size = mc_portal_size;
>>>> +	if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS)
>>>> +		spin_lock_init(&mc_io->spinlock);
>>>
>>> I'm confused - this patseries doesn't register an interrupt handler,
>>> so this can't be true (or it's premature if it will, in which case
>>> it should be left out for now).
>>>
>>> However, if somehow users of this code register an IRQ handler for
>>> the portal (I don't see any users to tell how they get the IRQ line
>>> either?), then it's up to them to establish mutual exclusion rules
>>> for access, among themselves.  Unless you think they will be calling
>>> mc_send_command from h/w IRQ context, in which case I'd reconsider
>>> that assumption because send_command looks like it'd take too long
>>> to get an answer from the h/w - IRQ handlers should just ack the h/w
>>> IRQ, and notify the scheduler that the driver has work to do (in s/w
>>> IRQ context perhaps).
>>>
>> Although not included in this patch series, there are cases in
>> subsequent patch series, in which mc_send_command() will need to be
>> called from interrupt context.
>>
>> For example, the dprc_get_irq_status() needs to be called from the DPRC
>> ISR to determine the actual cause of the interrupt. Also, to clear
>> the interrupt the dprc_clear_irq_status() needs to be called from the
>> ISR. Both od these functions call mc_send_command():
>
> yet mc_send_command itself has the capability to trigger a h/w IRQ,
> no?  So how is that expected to work, given h/w IRQ handlers run
> with IRQs turned off?
>
"MC command completion" interrupts has not been implemented in the MC 
firmware, so sending a command to the MC does not currently trigger an 
interrupt by itself. I imagine that when "MC completion interrupts" get 
implemented, a flag will be available in the MC command header to 
indicate whether or not a "completion interrupt" is wanted. Different
MC commands have different latencies. So, enabling generation
of completion interrupts, is something that should be done only
for long-latency MC commands. For low-latency MC commands commands,
(including those that can be called in interrupt context) such as 
inspecting interrupt status or clearing interrupts, polling for 
completion would be a more efficient choice.

>>>> +	else if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS)
>>>> +		mutex_init(&mc_io->mutex);
>>>
>>> I'd assume SHARED_BY_THREADS to always be true in linux.
>>>
>> Not, if mc_send_command() is called from interrupt context, as
>> explained above. However, since this patch series does not include
>> any interrupt handlers, we can remove the
>> FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS flag and the associated spinlock,
>> from this patch series.
>>
>>>> +	res = devm_request_mem_region(dev,
>>>> +				      mc_portal_phys_addr,
>>>> +				      mc_portal_size,
>>>> +				      "mc_portal");
>>>> +	if (res == NULL) {
>>>> +		dev_err(dev,
>>>> +			"devm_request_mem_region failed for MC portal %#llx\n",
>>>> +			mc_portal_phys_addr);
>>>> +		return -EBUSY;
>>>> +	}
>>>> +
>>>> +	mc_portal_virt_addr = devm_ioremap_nocache(dev,
>>>> +						   mc_portal_phys_addr,
>>>> +						   mc_portal_size);
>>>> +	if (mc_portal_virt_addr == NULL) {
>>>> +		dev_err(dev,
>>>> +			"devm_ioremap_nocache failed for MC portal %#llx\n",
>>>> +			mc_portal_phys_addr);
>>>> +		return -ENXIO;
>>>> +	}
>>>> +
>>>> +	mc_io->portal_virt_addr = mc_portal_virt_addr;
>>>> +	*new_mc_io = mc_io;
>>>> +	return 0;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(fsl_create_mc_io);
>>>> +
>>>> +void fsl_destroy_mc_io(struct fsl_mc_io *mc_io)
>>>> +{
>>>> +	if (WARN_ON(mc_io->portal_virt_addr == NULL))
>>>> +		return;
>>>
>>> this is unnecessary - you'll get the stack trace anyway, and users
>>> calling destroy on a not successfully created mc_io object should
>>> not get the luxury of maybe being able to continue after the stack
>>> trace, after possibly leaking memory.
>> Ok, I'ĺl remove this WARN_ON in the v3 respin.
>
> subsequent code will cause a stack trace when dereferencing
> portal_virt_addr anyway, so the if statement isn't needed at all.
>
I meant to remove both the 'if' and the WARN_ON, as obviously keeping 
the 'if' without the WARN_ON is bad as it would silently hide a bug.

>>>> +	mc_io->portal_virt_addr = NULL;
>>>> +	devm_kfree(mc_io->dev, mc_io);
>>>
>>> like I said before, there's really no point in clearing something
>>> out right before it's freed.
>>>
>> I disagree. This can help detect cases of double-freeing.
>
> ?  freeing NULL does nothing - it just returns - which doesn't help
> detect anything.  What's more, the kernel has a memory debugging
> infrastructure that detects double freeing of the same object.
I know that, but silently doing nothing when freeing NULL is a bad 
practice in general, because it hides a bug. Is the memory debugging 
infrastructure enabled by default? If so, then I would agree with you. 
If not, we would need to be able to reproduce the bug while having
memory debugging enabled. This assumes that the bug is easy to
reproduce. What if it is not easy to reproduce?
Having "first-failure data capture" checks is useful for helping
diagnose bugs that are not easy to reproduce.

In this case, if due to some bug, fsl_destroy_mc_io() is
called twice for the same mc_io object, the combination of doing
"mc_io->portal_virt_addr = NULL" and the original "if (WARN_ON",
that you want removed, would have helped catch the bug on
"first failure".
Even removing the "if (WARN_ON)" but keeping the
"mc_io->portal_virt_addr = NULL" would still help catch the bug
on "first failure", assuming that the system crashes when calling
"devm_iounmap(mc_io->dev, NULL);" or at least prints a stack trace.

> >>>
>>>> + * Delay in microseconds between polling iterations while
>>>> + * waiting for MC command completion
>>>> + */
>>>> +#define MC_CMD_COMPLETION_POLLING_INTERVAL_USECS    500	/* 0.5 ms */
>>>> +
>>>> +int __must_check fsl_create_mc_io(struct device *dev,
>>>> +				  phys_addr_t mc_portal_phys_addr,
>>>> +				  uint32_t mc_portal_size,
>>>> +				  uint32_t flags, struct fsl_mc_io **new_mc_io)
>>>> +{
>>>> +	struct fsl_mc_io *mc_io;
>>>> +	void __iomem *mc_portal_virt_addr;
>>>> +	struct resource *res;
>>>> +
>>>> +	mc_io = devm_kzalloc(dev, sizeof(*mc_io), GFP_KERNEL);
>>>> +	if (mc_io == NULL)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	mc_io->dev = dev;
>>>> +	mc_io->flags = flags;
>>>> +	mc_io->portal_phys_addr = mc_portal_phys_addr;
>>>> +	mc_io->portal_size = mc_portal_size;
>>>> +	if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS)
>>>> +		spin_lock_init(&mc_io->spinlock);
>>>
>>> I'm confused - this patseries doesn't register an interrupt handler,
>>> so this can't be true (or it's premature if it will, in which case
>>> it should be left out for now).
>>>
>>> However, if somehow users of this code register an IRQ handler for
>>> the portal (I don't see any users to tell how they get the IRQ line
>>> either?), then it's up to them to establish mutual exclusion rules
>>> for access, among themselves.  Unless you think they will be calling
>>> mc_send_command from h/w IRQ context, in which case I'd reconsider
>>> that assumption because send_command looks like it'd take too long
>>> to get an answer from the h/w - IRQ handlers should just ack the h/w
>>> IRQ, and notify the scheduler that the driver has work to do (in s/w
>>> IRQ context perhaps).
>>>
>> Although not included in this patch series, there are cases in
>> subsequent patch series, in which mc_send_command() will need to be
>> called from interrupt context.
>>
>> For example, the dprc_get_irq_status() needs to be called from the DPRC
>> ISR to determine the actual cause of the interrupt. Also, to clear
>> the interrupt the dprc_clear_irq_status() needs to be called from the
>> ISR. Both od these functions call mc_send_command():
>
>>>> +int mc_send_command(struct fsl_mc_io *mc_io, struct mc_command *cmd)
>>>> +{
>>>> +	enum mc_cmd_status status;
>>>> +	int error;
>>>> +	unsigned long irqsave_flags = 0;
>>>> +	unsigned long jiffies_until_timeout =
>>>> +	    jiffies + MC_CMD_COMPLETION_TIMEOUT_JIFFIES;
>>>> +
>>>> +	/*
>>>> +	 * Acquire lock depending on mc_io flags:
>>>> +	 */
>>>> +	if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS) {
>>>> +		if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS)
>>>> +			spin_lock_irqsave(&mc_io->spinlock, irqsave_flags);
>>>> +		else
>>>> +			spin_lock(&mc_io->spinlock);
>>>> +	} else if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS) {
>>>> +		mutex_lock(&mc_io->mutex);
>>>> +	}
>>>
>>> again, I think we need to drop the coming from h/w IRQ context here
>>> (SHARED_BY_INT_HANDLERS); there's no IRQ handlers in this
>>> patchseries, and calling this function from an IRQ handler would be
>>> prohibitively wasteful, guessing by the udelay and timeout values
>>> below.
>>>
>>> Can we just mutex_lock for now, and unconditionally (no
>>> SHARED_BY_THREADS check), to protect from nesting?
>>>
>> I would still prefer to keep the SHARED_BY_THREADS flag, to give option
>> of not doing any locking, in cases where the portal used in
>> mc_send_command() is not shared among concurrent callers
>
> how can you guarantee there won't be concurrent callers?  The linux
> kernel is multithreaded.
>
The owner of the portal should know if his/her code can be invoked using 
the same portal, from multiple threads or not.

>> What do you mean by nesting in this case?
>
> when a thread gets interrupted by another thread, and/or another
> IRQ: this would cause an unrecoverable race condition.
>
>>>> +	/*
>>>> +	 * Wait for response from the MC hardware:
>>>> +	 */
>>>> +	for (;;) {
>>>> +		status = mc_read_response(mc_io->portal_virt_addr, cmd);
>>>> +		if (status != MC_CMD_STATUS_READY)
>>>> +			break;
>>>> +
>>>> +		/*
>>>> +		 * TODO: When MC command completion interrupts are supported
>>>> +		 * call wait function here instead of udelay()
>>>> +		 */
>>>> +		udelay(MC_CMD_COMPLETION_POLLING_INTERVAL_USECS);
>>>
>>> this pauses any caller for 0.5ms on every successful command
>>> write.  Can the next submission of the patchseries wait until
>>> completion IRQs are indeed supported, since both that and the above
>>> locking needs to be resolved?
>>>
>> No. Interrupt handlers will come in a later patch series as they are
>> not needed for using the basic MC functionality.
>
> meanwhile unnecessarily udelaying kernel threads for .5ms upsets
> basic kernel functionality :)  Would using the kernel's
> wait_for_completion API be a good compromise here?  See
> include/linux/completion.h.
>
The intent of doing the udelay() in the middle of the polling loop was 
to throttle down the frequency of I/Os done while polling for the
completion of the command. Can you elaborate on why ".5ms udelay upsets
basic kernel functionality"?

Would it be better to just use "plain delay loop", instead of the udelay 
call, such as the following?

for (i = 0; i < 1000; i++)
    ;

I can see that in the cases where we use "completion interrupts", the 
ISR can signal the completion, and the polling loop can be replaced by 
waiting on the completion. However, I don't see how using a completion 
can help make a polling loop more efficient, if you don't have a 
"completion interrupt" to signal the completion.

Thanks,

German
> Kim
>
