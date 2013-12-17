Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab3LQJ6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:58:01 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:42471 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab3LQJ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:57:57 -0500
Message-ID: <52B01FF2.8010801@st.com>
Date: Tue, 17 Dec 2013 09:57:06 +0000
From: Angus Clark <angus.clark@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100312 Lightning/1.0b2pre Shredder/3.0.1
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dwmw2@infradead.org>,
        <linus.walleij@linaro.org>, <linux-mtd@lists.infradead.org>,
        Angus CLARK <angus.clark@st.com>
Subject: Re: [PATCH v3 11/36] mtd: st_spi_fsm: Search for preferred FSM message
 sequence configurations
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org> <1385727565-25794-12-git-send-email-lee.jones@linaro.org> <20131211010636.GH27149@ld-irv-0074.broadcom.com>
In-Reply-To: <20131211010636.GH27149@ld-irv-0074.broadcom.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.49.178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 01:06 AM, Brian Norris wrote:
> This process sounds very much like something that is needed for other
> controllers: a way to match controller capabilties with the opcodes
> supported by the flash. 

Yes, I think this should be a primary aim of any 'spi-nor' framework".

> But it still isn't quite flexible enough for
> others, because it doesn't try to abstract the selection criteria -- it
> just uses lists that you presorted

Sure, the implementation here is very specific to the st_spi_fsm controller.
However, until there is something better or more generic available, I am not
sure what else to suggest.  Selecting a configuration based on a presorted list
is probably a reasonable strategy though; READ_1_4_4 is more efficient that
READ_1_1_4, and READ_1_1_4 is more efficient than READ_1_1_2 etc.

>> +/* Search for preferred configuration based on available flags */
>> +static struct seq_rw_config *
>> +stfsm_search_seq_rw_configs(struct stfsm *fsm,
>> +			    struct seq_rw_config cfgs[])
>> +{
>> +	struct seq_rw_config *config;
>> +	int flags = fsm->info->flags;
>> +
>> +	for (config = cfgs; cfgs->cmd != 0; config++)
> 
> This becomes an infinite loop if you can't find a matching config. You
> probably meant 'config->cmd != 0':
> 

I will leave Lee to defend himself on this one ;-)

>> +/* Parameters to configure a READ or WRITE FSM sequence */
>> +struct seq_rw_config {
>> +	uint8_t		mode_data;	/* MODE data */
> 
> What does this represent? As far as I can see, all the configurations
> you provide so far have this entry as 0x00.
> 
>> +	uint8_t		mode_cycles;	/* No. of MODE cycles */
> 
> What are MODE cycles? (Sorry if these are dumb questions.)

Mode data cyles are similar to dummy cycles, except they also transmit some
extended information on how the device should perform the transfer.  For
example, Spansion devices use mode data to enter/exit a "continuous read mode"
where subsequent read operations do not need to issue the read command, just
supply an address (and further mode/dummy cycles).  In practice, we have only
used this particular mode during testing; our boot-controller dislikes any form
of statefull mode!

> 
>> +	uint8_t		dummy_cycles;	/* No. of DUMMY cycles */
>> +};
> 
> Several pieces of this sequence struct seems suspiciously similar to
> what would be needed by several other controllers, while the remaining
> pieces don't seem to be so special that they cannot be configured
> beneath a SPI NOR framework. I'm becoming less convinced that your
> controller/driver is as unique as you say it is.

Other controllers/drivers would certainly benefit from something similar.
However, I thought the point was that no such framework exists at present and
any spi-nor proposal is going to take time to mature.  In the meantime,
integrating the st_spi_fsm driver would provide another example of H/W that
needs to be supported by a spi-nor framework, and maybe give a few ideas along
the way.

Cheers,

Angus

