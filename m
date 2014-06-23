Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaFWVsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:48:01 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58599 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaFWVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:47:59 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A8A084.3000005@roeck-us.net>
Date: Mon, 23 Jun 2014 14:47:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Arnd Bergmann <arnd@arndb.de>, dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com> <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com> <20140507213318.GA2105@roeck-us.net> <20140515091123.GQ29258@lukather> <20140519150422.GA27329@lukather> <20140522203444.GE27329@lukather> <20140522211207.GA28704@roeck-us.net> <20140623103142.GB19730@lukather> <53A83A20.6090800@roeck-us.net> <20140623154934.GG19730@lukather> <20140623213046.GR22347@spo001.leaseweb.com>
In-Reply-To: <20140623213046.GR22347@spo001.leaseweb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 02:30 PM, Wim Van Sebroeck wrote:
> Hi All,
>
>> On Mon, Jun 23, 2014 at 07:30:56AM -0700, Guenter Roeck wrote:
>>>>> The patches _are_ in my watchdog-next branch and get some coverage from
>>>>> both my auto-builders and from Fenguang's build robots, so while they are
>>>>> not in linux-next, they are not completely in the dark either.
>>>>
>>>> So, this patch finally didn't make it into 3.16. Great. Now, we can't
>>>> even reboot the boards.
>>>>
>>>> Given how it's just impossible to get something merged reliably
>>>> through the watchdog tree, I guess I should just start merging the
>>>> patches through mine?
>>>>
>>>
>>> You can not really blame Wim here.
>>>
>>> In this case, I suspect the major reason for not accepting the patch
>>> is that I tried to provide a clean method / API for "reset through watchdog
>>> subsystem", which went nowhere, in my understanding because someone objected
>>> that it would be the wrong thing to do [1] and it didn't get approval /
>>> acceptance from the arm maintainers. If it is wrong to reset the board
>>> from the watchdog subsystem in a clean way, it is for sure even more wrong
>>> to do it as you proposed in your patch.
>>>
>>> My conclusion therefore is that all board reset code should move back out
>>> of the watchdog subsystem, and that we should not accept such code in the
>>> future. This is not my personal preference, but I do believe that we should
>>> do it in a clean way or not at all.
>>
>> Well, considering that this patch isn't depending on your reboot API
>> set, and that Wim never either commented on this patch, your reboot
>> API patchset or your pull request to say that he was not willing to
>> merge this, there's still a huge failure to communicate.
>>
>> I'm fine with any technical reason, let's debate on that. But the
>> point is there has been no debate at all, only silence from his side.
>>
>> I have been told some patches would be merged and I merged through my
>> tree some patches that were depending on this one based on that
>> assumption.
>>
>> And now, we have a regression.
>>
>> Anyway... I guess I should just revert some commits now.
>>
>
> To continue the discussion: I would like to add an excerpt from drivers/watchdog/alim7101_wdt.c
> /*
>   *      Notifier for system down
>   */
>
> static int wdt_notify_sys(struct notifier_block *this,
>                                          unsigned long code, void *unused)
> {
>          if (code == SYS_DOWN || code == SYS_HALT)
>                  wdt_turnoff();
>
>          if (code == SYS_RESTART) {
>                  /*
>                   * Cobalt devices have no way of rebooting themselves other
>                   * than getting the watchdog to pull reset, so we restart the
>                   * watchdog on reboot with no heartbeat
>                   */
>                  wdt_change(WDT_ENABLE);
>                  pr_info("Watchdog timer is now enabled with no heartbeat - should reboot in ~1 second\n");
>          }
>          return NOTIFY_DONE;
> }
>
> For some systems the watchdog is the only way to reboot... So where we should put it, is not trivial neither...
>

Agreed. The above definitely doesn't look like a good solution to me.

Guenter

