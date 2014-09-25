Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaIYQof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:44:35 -0400
Received: from mail-by2on0128.outbound.protection.outlook.com ([207.46.100.128]:4353
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753808AbaIYQoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:44:34 -0400
Message-ID: <5424466A.1010103@freescale.com>
Date: Thu, 25 Sep 2014 11:44:26 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Kim Phillips <kim.phillips@freescale.com>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <stuart.yoder@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>,
        Erez Nir-RM30794 <nir.erez@freescale.com>
Subject: Re: [PATCH 1/3 v2] drivers/bus: Added Freescale Management Complex
 APIs
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>		<1411166981-3610-2-git-send-email-German.Rivera@freescale.com>		<20140923194901.894483bfaef97d13d12c75a5@freescale.com>		<54237CBF.2010706@freescale.com>	 <20140924224006.f924cefdd347464519da8190@freescale.com>	 <54243873.9060509@freescale.com> <1411661796.13320.191.camel@snotra.buserror.net>
In-Reply-To: <1411661796.13320.191.camel@snotra.buserror.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: BLUPR08CA0044.namprd08.prod.outlook.com (10.141.200.24) To
 BLUPR03MB328.namprd03.prod.outlook.com (10.141.48.27)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB328;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(377454003)(479174003)(377424004)(24454002)(199003)(51704005)(189002)(87976001)(83506001)(47776003)(107046002)(20776003)(80316001)(93886004)(19580395003)(19580405001)(81342003)(83322001)(46102003)(77982003)(101416001)(42186005)(99396003)(85306004)(65806001)(65956001)(120916001)(33656002)(83072002)(102836001)(66066001)(76482002)(64706001)(10300001)(77096002)(95666004)(85852003)(105586002)(50466002)(106356001)(4396001)(110136001)(21056001)(64126003)(97736003)(31966008)(50986999)(65816999)(87266999)(79102003)(76176999)(23676002)(74662003)(81542003)(74502003)(54356999)(80022003)(36756003)(92566001)(92726001)(86362001)(99136001)(90102001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB328;H:[10.214.84.145];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/25/2014 11:16 AM, Scott Wood wrote:
> On Thu, 2014-09-25 at 10:44 -0500, German Rivera wrote:
>>
>> On 09/24/2014 10:40 PM, Kim Phillips wrote:
>>> On Wed, 24 Sep 2014 21:23:59 -0500
>>> German Rivera <German.Rivera@freescale.com> wrote:
>>>
>>>> On 09/23/2014 07:49 PM, Kim Phillips wrote:
>>>>> On Fri, 19 Sep 2014 17:49:39 -0500
>>>>> "J. German Rivera" <German.Rivera@freescale.com> wrote:
>>>>>> +	mc_io->portal_virt_addr = NULL;
>>>>>> +	devm_kfree(mc_io->dev, mc_io);
>>>>>
>>>>> like I said before, there's really no point in clearing something
>>>>> out right before it's freed.
>>>>>
>>>> I disagree. This can help detect cases of double-freeing.
>>>
>>> ?  freeing NULL does nothing - it just returns - which doesn't help
>>> detect anything.  What's more, the kernel has a memory debugging
>>> infrastructure that detects double freeing of the same object.
>> I know that, but silently doing nothing when freeing NULL is a bad
>> practice in general, because it hides a bug.
>
> It doesn't hide a bug "in general".  I'm not sure what the relevance is
> here, though -- this seems to be about reusing portal_virt_addr as a
> debug flag rather than anything to do with actually calling free() on
> portal_virt_addr.
>
>> Is the memory debugging infrastructure enabled by default? If so, then
>> I would agree with you. If not, we would need to be able to reproduce
>> the bug while having memory debugging enabled. This assumes that the
>> bug is easy to reproduce. What if it is not easy to reproduce? Having
>> "first-failure data capture" checks is useful for helping diagnose bugs
>> that are not easy to reproduce.
>>
>> In this case, if due to some bug, fsl_destroy_mc_io() is
>> called twice for the same mc_io object, the combination of doing
>> "mc_io->portal_virt_addr = NULL" and the original "if (WARN_ON",
>> that you want removed, would have helped catch the bug on
>> "first failure".
>> Even removing the "if (WARN_ON)" but keeping the
>> "mc_io->portal_virt_addr = NULL" would still help catch the bug
>> on "first failure", assuming that the system crashes when calling
>> "devm_iounmap(mc_io->dev, NULL);" or at least prints a stack trace.
>
> iounmap of NULL will not crash or print a stack trace.  It is a no-op.
>
Ok, so if iounmap silently does nothing for NULL, and free silently does
nothing for NULL, that means we may not be be able to easily catch 
"destroy double-call" bugs on first-failure, in this case.
If that is not an issue, then I'll remove the "mc_io->portal_virt_addr = 
NULL" as well.

>>>>>> +int mc_send_command(struct fsl_mc_io *mc_io, struct mc_command *cmd)
>>>>>> +{
>>>>>> +	enum mc_cmd_status status;
>>>>>> +	int error;
>>>>>> +	unsigned long irqsave_flags = 0;
>>>>>> +	unsigned long jiffies_until_timeout =
>>>>>> +	    jiffies + MC_CMD_COMPLETION_TIMEOUT_JIFFIES;
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * Acquire lock depending on mc_io flags:
>>>>>> +	 */
>>>>>> +	if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS) {
>>>>>> +		if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS)
>>>>>> +			spin_lock_irqsave(&mc_io->spinlock, irqsave_flags);
>>>>>> +		else
>>>>>> +			spin_lock(&mc_io->spinlock);
>>>>>> +	} else if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS) {
>>>>>> +		mutex_lock(&mc_io->mutex);
>>>>>> +	}
>>>>>
>>>>> again, I think we need to drop the coming from h/w IRQ context here
>>>>> (SHARED_BY_INT_HANDLERS); there's no IRQ handlers in this
>>>>> patchseries, and calling this function from an IRQ handler would be
>>>>> prohibitively wasteful, guessing by the udelay and timeout values
>>>>> below.
>>>>>
>>>>> Can we just mutex_lock for now, and unconditionally (no
>>>>> SHARED_BY_THREADS check), to protect from nesting?
>>>>>
>>>> I would still prefer to keep the SHARED_BY_THREADS flag, to give option
>>>> of not doing any locking, in cases where the portal used in
>>>> mc_send_command() is not shared among concurrent callers
>>>
>>> how can you guarantee there won't be concurrent callers?  The linux
>>> kernel is multithreaded.
>>>
>> The owner of the portal should know if his/her code can be invoked using
>> the same portal, from multiple threads or not.
>
> Or more generally, whether the caller is responsible for
> synchronization.
>
> Would it make sense to simplify by saying the caller is always
> responsible for synchronization?
>
Certainly this will simplify mc_send_command() but it will put the 
additional burden on all the callers of MC commands. If there is no 
objection, we can remove locking entirely from mc_send_command() and
the the callers of MC commands deal with that.

> Then again, the management complex is not supposed to be on the
> performance critical path, so why not simplify by just always do the
> locking here?
>
But about the few MC commands that need to run on interrupt context
(such as to inspect or clear MC interrupts)?

>>>>>> +	/*
>>>>>> +	 * Wait for response from the MC hardware:
>>>>>> +	 */
>>>>>> +	for (;;) {
>>>>>> +		status = mc_read_response(mc_io->portal_virt_addr, cmd);
>>>>>> +		if (status != MC_CMD_STATUS_READY)
>>>>>> +			break;
>>>>>> +
>>>>>> +		/*
>>>>>> +		 * TODO: When MC command completion interrupts are supported
>>>>>> +		 * call wait function here instead of udelay()
>>>>>> +		 */
>>>>>> +		udelay(MC_CMD_COMPLETION_POLLING_INTERVAL_USECS);
>>>>>
>>>>> this pauses any caller for 0.5ms on every successful command
>>>>> write.  Can the next submission of the patchseries wait until
>>>>> completion IRQs are indeed supported, since both that and the above
>>>>> locking needs to be resolved?
>>>>>
>>>> No. Interrupt handlers will come in a later patch series as they are
>>>> not needed for using the basic MC functionality.
>>>
>>> meanwhile unnecessarily udelaying kernel threads for .5ms upsets
>>> basic kernel functionality :)  Would using the kernel's
>>> wait_for_completion API be a good compromise here?  See
>>> include/linux/completion.h.
>>>
>> The intent of doing the udelay() in the middle of the polling loop was
>> to throttle down the frequency of I/Os done while polling for the
>> completion of the command. Can you elaborate on why ".5ms udelay upsets
>> basic kernel functionality"?
>
> It introduces latency, especially since it's possible for it to happen
> with interrupts disabled.  And you're actually potentially blocking for
> more than that, since 500us is just one iteration of the loop.
>
> The jiffies test for exiting the loop is 500ms, which is *way* too long
> to spend in a critical section.
>
But that would be a worst case, since that is a timeout check.
What timeout value do you think would be more appropriate in this case?

>> Would it be better to just use "plain delay loop", instead of the udelay
>> call, such as the following?
>>
>> for (i = 0; i < 1000; i++)
>>      ;
>
> No, never do that.  You have no idea how long it will actually take.
> GCC might even optimize it out entirely.
>
Ok, so udelay is not good here, a plain vanilla delay loop is not good 
either. Are there other alternatives or we just don't worry about
throttling down the frequency of I/Os done in the polling loop?
(Given the fact that MC commands are not expected to be executed that 
frequently, to frequently cause a lot of I/O traffic with this polling loop)

>> I can see that in the cases where we use "completion interrupts", the
>> ISR can signal the completion, and the polling loop can be replaced by
>> waiting on the completion. However, I don't see how using a completion
>> can help make a polling loop more efficient, if you don't have a
>> "completion interrupt" to signal the completion.
>
> It's not about making it more efficient.  It's about not causing
> problems for other things going on in the system.
>
But still I don't see how a completion can help here, unless
you can signal the completion from an ISR.

-German

