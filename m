Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab3BIGre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 01:47:34 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:34121 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3BIGrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 01:47:32 -0500
Message-ID: <5115F076.5000909@synopsys.com>
Date: Sat, 9 Feb 2013 12:15:10 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 4/4] serial/arc-uart: switch to devicetree based probing
References: <1357885223-19243-1-git-send-email-vgupta@synopsys.com> <1357885223-19243-5-git-send-email-vgupta@synopsys.com> <20130208230127.5F3063E2C27@localhost>
In-Reply-To: <20130208230127.5F3063E2C27@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2013 04:31 AM, Grant Likely wrote:
> On Fri, 11 Jan 2013 11:50:23 +0530, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>> +- clock-frequency	: the input clock frequency for the UART
>> +- baud			: baud rate for UART
> change 'baud' to 'current-speed'. There is already precedence for this
> with other serial devices.

While I'm OK with this - I can only see of_serial.c following the rule :-)
More importantly I'm not clear about the logistics of this fix. Obviously this has
a bearing on DT files in arch/arc/boot/*. So are such changes (platform + driver)
routed thru the subsystem tree or the arch tree or bits from both with
bisectability not considered - which feels wrong. We have to also consider the
fact that Greg has closed the tty/serial for 3.9. So while I have no objection to
your comment, it seems that the it needs to wait till 3.9-rc1 - or is there an
alternate way.

>
>> @@ -673,8 +693,18 @@ static int __init arc_serial_probe_earlyprintk(struct platform_device *pdev)
>>  static int arc_serial_probe(struct platform_device *pdev)
>>  {
>>  	int rc, dev_id;
>> +	struct device_node *np = pdev->dev.of_node;
>> +
>> +	/* no device tree device */
>> +	if (!np)
>> +		return -ENODEV;
> This breaks non-DT users. Is this what you intend? It creates a flag day
> where users have to switch from non-DT to DT cold-turkey.

Not supporting non-DT user was not the idea - it just simplifies the code a bit
given that it would only even be runtime used in a ARC Linux port based platform -
which unconditionally enables OF.  Further - the ARC port itself is not yet
upstream so there are no "official" user of this in tree driver.
FWIW, ARC Linux port was recently reviewed on lkml/arch mailing lists and is now
in linux-next for a possible 3.9 merge.

>> +	dev_id = of_alias_get_id(np, "serial");
>> +	if (dev_id < 0) {
>> +		dev_err(&pdev->dev, "failed to get alias id: %d\n", dev_id);
>> +		return dev_id;
>> +	}
> Don't fail on this. If you can't get an id then choose one dynamically.

You mean just assume 0.

Thanks for reviewing.
-Vineet
