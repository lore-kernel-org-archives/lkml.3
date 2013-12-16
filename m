Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab3LPR2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:28:49 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:47257 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab3LPR2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:28:47 -0500
Message-ID: <52AF384C.9020101@linux.com>
Date: Mon, 16 Dec 2013 18:28:44 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Paul Bolle <pebolle@tiscali.nl>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ahci: only attach ICH6-M if it's in SATA mode
References: <1387190097.9255.31.camel@x41.thuisdomein> <20131216155136.GF32509@htj.dyndns.org>
In-Reply-To: <20131216155136.GF32509@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 04:51 PM, Tejun Heo wrote:
> Hello, Paul.
> 
> On Mon, Dec 16, 2013 at 11:34:57AM +0100, Paul Bolle wrote:
>> Intel's ICH6-M can operate either in IDE mode or in SATA mode. Attaching
>> in IDE mode is pointless (and should fail, as long as BIOS has configured
>> it even remotely sane). So let's only attach in SATA mode.
>>
>> Note that ata_piix does the opposite: only attach if ICH6-M is in IDE
>> mode, so we end up with just one driver attaching in either mode.
>>
>> (And since we're touching this table update a minor typo too.)
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> Tested on an ICH6-M that always runs in IDE mode. So I'm not certain
>> this does the right thing for a ICH6-M running in SATA mode. 
>>
>>  drivers/ata/ahci.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>> index 4ba3bde..12182fd 100644
>> --- a/drivers/ata/ahci.c
>> +++ b/drivers/ata/ahci.c
>> @@ -191,8 +191,10 @@ static const struct ata_port_info ahci_port_info[] = {
>>  
>>  static const struct pci_device_id ahci_pci_tbl[] = {
>>  	/* Intel */
>> -	{ PCI_VDEVICE(INTEL, 0x2652), board_ahci }, /* ICH6 */
>> -	{ PCI_VDEVICE(INTEL, 0x2653), board_ahci }, /* ICH6M */
>> +	{ PCI_VDEVICE(INTEL, 0x2652), board_ahci }, /* ICH6R */
>> +	/* ICH6M Attach iff the controller is in SATA mode. */
>> +	{ PCI_VENDOR_ID_INTEL, 0x2653, PCI_ANY_ID, PCI_ANY_ID,
>> +	  PCI_CLASS_STORAGE_SATA << 8, 0xffff00, board_ahci },
> 
> I'm not quite sure about this one.  The patch seems correct on the
> surface but given how old ich6 is at this point, the general
> crappiness of BIOS on ahci front in that era, and that the existing
> code has been working fine for all these years make me very reluctant
> to change it.  e.g. I don't think CLASS_STORAGE_SATA was the only one.
> They used different class for raid too.  It should be able to figure
> out things given enough test cases but I don't think we have that
> anymore and the benefit (avoding probe failure messages) doesn't seem
> to justify the risk.

Not only they use different class IDs, but IIRC they also change device ids.
For example, ICH7M was 0x27C4 in AHCI mode and 0x27DF in IDE mode. (obviously
Intel vendor ids)

Paul, did this patch change anything noticeable for you? I mean was there any
problem before that this patch fixes or not?


-- 
Regards,
Levente Kurusa
