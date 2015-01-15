Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbbAOKX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:23:58 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54089 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbAOKXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:23:54 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-dc-54b795381a8f
Message-id: <54B79536.5090300@samsung.com>
Date: Thu, 15 Jan 2015 11:23:50 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: balbi@ti.com, Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yousaf.kaukab@intel.com" <yousaf.kaukab@intel.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
References: <20150114211434.GT16533@saruman>
 <Pine.LNX.4.44L0.1501141636590.1464-100000@iolanthe.rowland.org>
 <20150114214603.GU16533@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E03048450771B@US01WEMBX2.internal.synopsys.com>
 <20150114223941.GV16533@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E03048450774D@US01WEMBX2.internal.synopsys.com>
 <20150114224937.GY16533@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E030484507789@US01WEMBX2.internal.synopsys.com>
 <20150115062436.GA6615@saruman>
In-reply-to: <20150115062436.GA6615@saruman>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xy7oWU7eHGFzcz2Zx8H69xapPa5gt
	mhevZ7O4vGsOm8WiZa3MFmuP3GW3ePRwK6vFhN8X2Cw2bfrJ7MDpsXjPSyaP/XPXsHv0X5vE
	7jH77g9Gj74tqxg9tuz/zOhx/MZ2Jo/Pm+QCOKK4bFJSczLLUov07RK4Mpb+fstccEal4uD7
	acwNjIdluxg5OSQETCR+rXrFBGGLSVy4t54NxBYSWMoosWmWTRcjF5D9kVHiz8mLrCAJXgEt
	iSePGlm6GDk4WARUJW6cUAIJswnoSGz5PoERxBYViJD4sOorG0S5oMSPyfdYQGwRATuJ5au6
	2EBmMgvMYJbYtmEl2ExhgWCJ/30nWSGWPWGWmHxxGyvIAk6gqTtuB4GYzAJ6EvcvaoGUMwvI
	S2xe85Z5AqPALCQrZiFUzUJStYCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSER82cG4
	+JjVIUYBDkYlHl4Gv+0hQqyJZcWVuYcYJTiYlUR4O3OAQrwpiZVVqUX58UWlOanFhxiZODil
	Ghjrm6bFzG77selJWOD89Lrlj74rTmh81/X4l2FSAL9Jv/7nd5Zbm3bbxaS/P6GR8ySjvn9y
	keJ+/7c7mOQ5FAoLekL0Xt98uSVeos6KW2e74B7tqpX2020u6L2WEON/8f7HwxpZtmtfVjN9
	fnuwJofxMMsh3/5bLy3PN/p/4nnjfWpLpe3ygJVKLMUZiYZazEXFiQBO9RXVZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/15/2015 07:24 AM, Felipe Balbi wrote:
>>>>>>>>>>> This is really, really odd. Register accesses are atomic, so the lock
>>>>>>>>>>> isn't really doing anything. Besides, you're calling
>>>>>>>>>>> dwc2_is_controller_alive() from within the IRQ handler, so IRQs are
>>>>>>>>>>> already disabled.
>>>>>>>>>>
>>>>>>>>>> Spinlocks sometimes do more than you think.  For instance, here the
>>>>>>>>>> lock prevents the register access from happening while some other CPU
>>>>>>>>>> is holding the lock.  If a silicon quirk causes the register access to
>>>>>>>>>> interfere with other activities, this could be important.
>>>>>>>>>
>>>>>>>>> readl() (which is used by dwc2_is_controller_alive()) adds a memory
>>>>>>>>> barrier to the register accesses, that should force all register
>>>>>>>>> accesses the be correctly ordered.
>>>>>>>>
>>>>>>>> Memory barriers will order accesses that are all made on the same CPU
>>>>>>>> with respect to each other.  They do not order these accesses against
>>>>>>>> accesses made from another CPU -- that's why we have spinlocks.  :-)
>>>>>>>
>>>>>>> a fair point :-) The register is still read-only, so that shouldn't
>>>>>>> matter either :-)
>>>>>>>
>>>>>>>>>  I fail to see how a silicon quirk
>>>>>>>>> could cause this and if, indeed, it does, I'd be more comfortable with a
>>>>>>>>> proper STARS tickect number from synopsys :-s
>>>>>>>>
>>>>>>>> Maybe accessing this register somehow resets something else.  I don't
>>>>>>>> know.  It seems unlikely, but at least it explains how adding a
>>>>>>>> spinlock could fix the problem.
>>>>>>>
>>>>>>> I would really need Paul (or someone at Synopsys) to confirm this
>>>>>>> somehow. Maybe it has something to do with how the register is
>>>>>>> implemented, dunno.
>>>>>>>
>>>>>>> Paul, do you have any idea what could cause this ? Could the HW into
>>>>>>> some weird state if we read GSNPSID at random locations or when data is
>>>>>>> being transferred, or anything like that ?
>>>>>>
>>>>>> Only thing I can think of is that there is some silicon bug in Robert's
>>>>>> platform. But I am not aware of any STARs that mention accesses to the
>>>>>> GSNPSID register as being problematic.
>>>>>>
>>>>>> Funny thing is, this code has been basically the same since at least
>>>>>> November 2013. So I think some other recent change must have modified
>>>>>> the timing of the register accesses, or something like that. But that's
>>>>>> just handwaving, really.
>>>>>
>>>>> Alright, I'll apply this patch but for 3.20 with a stable tag as I have
>>>>> already sent my last pull request to Greg. Unless someone has a really
>>>>> big complaint about doing things as such.
>>>>
>>>> It should go to 3.19-rc shouldn't it? It's a fix, and Robert's platform
>>>> is broken without it, IIUC.
>>>
>>> It can also be categorized as "has-never-worked-before" before the code
>>> has been like this forever. Since we don't really have a git bisect
>>> result pointing to a commit that went in v3.19 merge window, I'm not
>>> sure how I can convince myself that this absolutely needs to be in
>>> v3.19.
>>>
>>> At a minimum, I need a proper bisection with a proper commit being
>>> blamed (even if it's a commit from months ago). From my point of view,
>>> debugging of this "regression" has not been finalized and we're just
>>> "assuming" it's caused by GSNPSID because moving that inside the
>>> spin_lock seems to fix the problem.
>>
>> On further investigation, I was wrong about "this code has been
>> basically the same since at least November 2013". Prior to commit
>> db8178c33db "usb: dwc2: Update common interrupt handler to call gadget
>> interrupt handler" from November 2014, the gadget interrupt handler
>> did not read from the GSNPSID register.
> 
> right, but the common IRQ always did. So unless Robert's SoC has always
> been used only for peripheral, then I agree with you that behavior did,
> in fact, change.

As far as I know, DWC2 at this platform was always used as peripheral.
Exynos SoC's has EHCI USB controllers, so in 99% of cases there is
simply no need to use DWC2 as host.

> 
>> So likely the bug in Robert's hardware has been there all along, and
>> that commit just caused it to manifest itself.
> 
> Robert, out of curiosity, which SoC are you using ? Is it UP or SMP ?
> 
> I guess we need a mention on commit log that at least SoC XYZ is known
> to break unless the register access is done with locks held.
> 

I'm using Exynos4412 (Odroid U3). Revision number of my DWC2 is 2.81a.

I will update commit message and send patch v3.

Thanks,
Robert Baldyga
