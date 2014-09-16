Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaIPTmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:42:38 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:56901 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbaIPTma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:42:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140912184432.GR12361@n2100.arm.linux.org.uk>
References: <1410450558-12358-1-git-send-email-mathieu.poirier@linaro.org>
	<1410450558-12358-2-git-send-email-mathieu.poirier@linaro.org>
	<20140912184432.GR12361@n2100.arm.linux.org.uk>
Date: Tue, 16 Sep 2014 13:42:29 -0600
Message-ID: <CANLsYky+fC3_rjUj=wC11Ww+hk8DxhPLs=pY2hODOCR99aXy6w@mail.gmail.com>
Subject: Re: [PATCH 01/11 v6] coresight: add CoreSight core layer framework
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Kaixu Xia <kaixu.xia@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "r.sengupta@samsung.com" <r.sengupta@samsung.com>,
        Robert Marklund <robbelibobban@gmail.com>,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deepak Saxena <dsaxena@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2014 12:44, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> Further to Greg's comments...
>
> On Thu, Sep 11, 2014 at 09:49:08AM -0600, mathieu.poirier@linaro.org wrote:
>> +int coresight_enable(struct coresight_device *csdev)
>> +{
>> +     int ret = 0;
>> +     LIST_HEAD(path);
>> +
>> +     WARN_ON(IS_ERR_OR_NULL(csdev));
>
> Please don't do this kind of checking, it just makes stuff a lot more
> noisy than it needs to be, and it doesn't give any value what so ever.
>
> I've seen code where it seems the coding style required that quite
> literally every function does extensive checking of function arguments,
> and every function returns a status.  This does nothing to stop bugs.
> In fact, it makes things a /lot/ worse because there is then soo much
> junk in every function that you can't read what the function is doing
> anymore.  Imagine memset() validating its arguments and returning a
> status value... I kid not.
>
> The point here is that if a NULL pointer is passed to this function,
> the above WARN_ON gets triggered, and we get a backtrace.  We then
> continue on, take the semaphore, and then dereference the NULL pointer
> causing another backtrace.  So the WARN_ON was utterly pointless.
>
> Just reference the pointer and don't bother with these silly checks.

Very well.

>
>> +
>> +     down(&coresight_semaphore);
>
> What is your reason for using a semaphore rather than a mutex?

Thanks for insisting on this - after doing a little more research on
the topic I will be moving to a mutex implementation.

>
> ...
>> +/**
>> + * coresight_timeout - loop until a bit has changed to a specific state.
>> + * @addr: base address of the area of interest.
>> + * @offset: address of a register, starting from @addr.
>> + * @position: the position of the bit of interest.
>> + * @value: the value the bit should have.
>> + *
>> + * Returns as soon as the bit has taken the desired state or TIMEOU_US has
>
> Typo?

Indeed.

>
>> + * elapsed, which ever happens first.
>> + */
>> +
>> +void coresight_timeout(void __iomem *addr, u32 offset, int position, int value)
>> +{
>> +     int i;
>> +     u32 val;
>> +
>> +     for (i = TIMEOUT_US; i > 0; i--) {
>> +             val = __raw_readl(addr + offset);
>> +             /* waiting on the bit to go from 0 to 1 */
>> +             if (value) {
>> +                     if (val & BIT(position))
>> +                             return;
>> +             /* waiting on the bit to go from 1 to 0 */
>> +             } else {
>> +                     if (!(val & BIT(position)))
>> +                             return;
>> +             }
>> +
>> +             /* The specification doesn't say how long we are expected
>> +              * to wait.
>> +              */
>
>                 /*
>                  * The kernel commeting style for multi-line comments is
>                  * like this.  Note the line opening the comment has no
>                  * comment text.
>                  */
>
>> +             udelay(1);
>
> So the duration is arbitary.

Correct.

>
>> +     }
>> +
>> +     WARN(1,
>> +          "coresight: timeout observed when proving at offset %#x\n",
>> +          offset);
>
> This is also buggy.  On the last loop iteration, we delay 1us, decrement
> i, and then test for it being greater than zero.  If it isn't, print
> this message and do a backtrace (why is a backtrace useful here?)
> The important point here is that we waited for 1us, and /didn't/ test
> for success before claiming timeout.  That makes the final 1us wait
> entirely useless.

Good catch.

>
>> diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
>> new file mode 100644
>> index 0000000..c780b4b
>> --- /dev/null
>> +++ b/drivers/coresight/of_coresight.c
>> @@ -0,0 +1,201 @@
> ...
>> +struct coresight_platform_data *of_get_coresight_platform_data(
>> +                             struct device *dev, struct device_node *node)
>> +{
>> +     int id, i = 0, ret = 0;
>> +     struct device_node *cpu;
>> +     struct coresight_platform_data *pdata;
>> +     struct of_endpoint endpoint, rendpoint;
>> +     struct device_node *ep = NULL;
>> +     struct device_node *rparent = NULL;
>> +     struct device_node *rport = NULL;
>> +
>> +     pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +     if (!pdata)
>> +             return ERR_PTR(-ENOMEM);
>
> So, what are the rules for calling this function?  What is the expected
> lifetime of this pdata structure in relation to 'dev' ?
>
> You do realise that when a driver unbinds from 'dev', this allocation
> will be freed.  If you hold on to the pointer and dereference it, you
> could be accessing memory allocated for other purposes at that point.

By the time the allocation of pdata is freed the driver will have
called "coresight_unregister()", removing all knowledge of that entity
by the framework.

>
>> diff --git a/include/linux/coresight.h b/include/linux/coresight.h
>> new file mode 100644
>> index 0000000..5b22287
>> --- /dev/null
>> +++ b/include/linux/coresight.h
>> @@ -0,0 +1,275 @@
> ...
>> +/**
>> + * @name:    name of the entry to appear under the component's
>> +             debugfs sub-directory.
>> + * @mode:    what operation can be performed on the entry.
>> + * @ops:     specific manipulation to be done using this entry.
>> + */
>
> Wrong commenting style.  Please read Documentation/kernel-doc-nano-HOWTO.txt
> for information how to document structures.

Ok.

>
> --
> FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
> according to speedtest.net.
