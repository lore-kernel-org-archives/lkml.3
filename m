Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765Ab3GECxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 22:53:50 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:42250 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3GECxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 22:53:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAO_0yfOXfO1ZNTNbYRnuY-CQ44hH+DqoEB5jnCwfhLPTq-RUqQ@mail.gmail.com>
References: <1372941783-30657-1-git-send-email-adam.lee@canonical.com> <CAO_0yfOXfO1ZNTNbYRnuY-CQ44hH+DqoEB5jnCwfhLPTq-RUqQ@mail.gmail.com>
From: Yang Bai <hamo.by@gmail.com>
Date: Fri, 5 Jul 2013 10:53:28 +0800
Message-ID: <CAO_0yfMEvB-TDaB9D7JdvaNozSvp1ogUoGtP=rzSxcup0x68Ww@mail.gmail.com>
Subject: Re: [PATCH] btusb: fix overflow return values
To: Adam Lee <adam.lee@canonical.com>
Cc: linux-bluetooth@vger.kernel.org,
        Wen-chien Jesse Sung <jesse.sung@canonical.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        "Anthony Wong'" <anthony.wong@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend without HTML format.

The return value of btusb_setup_intel is compared with 0. Code as:

drivers/bluetooth/btusb.c:
static int btusb_probe(struct usb_interface *intf,
const struct usb_device_id *id) {

if (id->driver_info & BTUSB_INTEL)
hdev->setup = btusb_setup_intel;

}

net/bluetooth/hci_core.c:
int hci_dev_open(__u16 dev) {

if (hdev->setup && test_bit(HCI_SETUP, &hdev->dev_flags))
ret = hdev->setup(hdev);

if (!ret) {
...
}

}


Thanks,
Yang

On Fri, Jul 5, 2013 at 10:37 AM, Yang Bai <hamo.by@gmail.com> wrote:
> The return value of btusb_setup_intel is compared with 0. Code as:
>
> drivers/bluetooth/btusb.c:
> static int btusb_probe(struct usb_interface *intf,
> const struct usb_device_id *id)
> if (id->driver_info & BTUSB_INTEL)
> hdev->setup = btusb_setup_intel;
>
> net/bluetooth/hci_core.c:
> int hci_dev_open(__u16 dev)
> if (hdev->setup && test_bit(HCI_SETUP, &hdev->dev_flags))
> ret = hdev->setup(hdev);
>
> if (!ret) {
>
>
> Thanks,
> Yang
>
>
>
> On Thu, Jul 4, 2013 at 8:43 PM, Adam Lee <adam.lee@canonical.com> wrote:
>>
>> PTR_ERR() returns a long type value, but btusb_setup_intel() and
>> btusb_setup_intel_patching() should return an int type value.
>>
>> This bug makes the judgement "if (ret < 0)" not working on x86_64
>> architecture systems, leading to failure as below, even panic.
>>
>> [   12.958920] Bluetooth: hci0 command 0xfc8e tx timeout
>> [   14.961765] Bluetooth: hci0 command 0xfc8e tx timeout
>> [   16.964688] Bluetooth: hci0 command 0xfc8e tx timeout
>> [   20.954501] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed
>> (-110)
>> [   22.957358] Bluetooth: hci0 command 0xfc8e tx timeout
>> [   30.948922] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed
>> (-110)
>> [   32.951780] Bluetooth: hci0 command 0xfc8e tx timeout
>> [   40.943359] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed
>> (-110)
>> [   42.946219] Bluetooth: hci0 command 0xfc8e tx timeout
>> [   50.937812] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed
>> (-110)
>> [   52.940670] Bluetooth: hci0 command 0xfc8e tx timeout
>> [   60.932236] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed
>> (-110)
>> [   62.935092] Bluetooth: hci0 command 0xfc8e tx timeout
>> [   70.926688] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed
>> (-110)
>> [   72.929545] Bluetooth: hci0 command 0xfc8e tx timeout
>> [   80.921111] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed
>> (-110)
>> [   82.923969] Bluetooth: hci0 command 0xfc2f tx timeout
>> [   90.915542] Bluetooth: hci0 sending Intel patch command (0xfc2f) failed
>> (-110)
>> [   92.918406] Bluetooth: hci0 command 0xfc11 tx timeout
>> [  100.909955] Bluetooth: hci0 sending Intel patch command (0xfc11) failed
>> (-110)
>> [  102.912858] Bluetooth: hci0 command 0xfc60 tx timeout
>> [  110.904394] Bluetooth: hci0 sending Intel patch command (0xfc60) failed
>> (-110)
>> [  112.907293] Bluetooth: hci0 command 0xfc11 tx timeout
>> [  120.898831] Bluetooth: hci0 exiting Intel manufacturer mode failed
>> (-110)
>> [  120.904757] bluetoothd[1030]: segfault at 4 ip 00007f8b2eb55236 sp
>> 00007fff53ff6920 error 4 in bluetoothd[7f8b2eaff000+cb000]
>>
>> For not affecting other modules, I choose to modify the return values
>> but not extend btusb_setup_intel() and btusb_setup_intel_patching()'s
>> return types. This is harmless, because the return values were only
>> used to comparing number 0.
>>
>> Signed-off-by: Adam Lee <adam.lee@canonical.com>
>> ---
>>  drivers/bluetooth/btusb.c | 14 +++++++-------
>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
>> index 7a7e5f8..0fb2799 100644
>> --- a/drivers/bluetooth/btusb.c
>> +++ b/drivers/bluetooth/btusb.c
>> @@ -1092,7 +1092,7 @@ static int btusb_setup_intel_patching(struct hci_dev
>> *hdev,
>>         if (IS_ERR(skb)) {
>>                 BT_ERR("%s sending Intel patch command (0x%4.4x) failed
>> (%ld)",
>>                        hdev->name, cmd->opcode, PTR_ERR(skb));
>> -               return -PTR_ERR(skb);
>> +               return -EFAULT;
>>         }
>>
>>         /* It ensures that the returned event matches the event data read
>> from
>> @@ -1144,7 +1144,7 @@ static int btusb_setup_intel(struct hci_dev *hdev)
>>         if (IS_ERR(skb)) {
>>                 BT_ERR("%s sending initial HCI reset command failed
>> (%ld)",
>>                        hdev->name, PTR_ERR(skb));
>> -               return -PTR_ERR(skb);
>> +               return -EFAULT;
>>         }
>>         kfree_skb(skb);
>>
>> @@ -1158,7 +1158,7 @@ static int btusb_setup_intel(struct hci_dev *hdev)
>>         if (IS_ERR(skb)) {
>>                 BT_ERR("%s reading Intel fw version command failed (%ld)",
>>                        hdev->name, PTR_ERR(skb));
>> -               return -PTR_ERR(skb);
>> +               return -EFAULT;
>>         }
>>
>>         if (skb->len != sizeof(*ver)) {
>> @@ -1216,7 +1216,7 @@ static int btusb_setup_intel(struct hci_dev *hdev)
>>                 BT_ERR("%s entering Intel manufacturer mode failed (%ld)",
>>                        hdev->name, PTR_ERR(skb));
>>                 release_firmware(fw);
>> -               return -PTR_ERR(skb);
>> +               return -EFAULT;
>>         }
>>
>>         if (skb->data[0]) {
>> @@ -1273,7 +1273,7 @@ static int btusb_setup_intel(struct hci_dev *hdev)
>>         if (IS_ERR(skb)) {
>>                 BT_ERR("%s exiting Intel manufacturer mode failed (%ld)",
>>                        hdev->name, PTR_ERR(skb));
>> -               return -PTR_ERR(skb);
>> +               return -EFAULT;
>>         }
>>         kfree_skb(skb);
>>
>> @@ -1289,7 +1289,7 @@ exit_mfg_disable:
>>         if (IS_ERR(skb)) {
>>                 BT_ERR("%s exiting Intel manufacturer mode failed (%ld)",
>>                        hdev->name, PTR_ERR(skb));
>> -               return -PTR_ERR(skb);
>> +               return -EFAULT;
>>         }
>>         kfree_skb(skb);
>>
>> @@ -1307,7 +1307,7 @@ exit_mfg_deactivate:
>>         if (IS_ERR(skb)) {
>>                 BT_ERR("%s exiting Intel manufacturer mode failed (%ld)",
>>                        hdev->name, PTR_ERR(skb));
>> -               return -PTR_ERR(skb);
>> +               return -EFAULT;
>>         }
>>         kfree_skb(skb);
>>
>> --
>> 1.8.3.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
>
> --
>     """
>     Keep It Simple,Stupid.
>     """
>
> Chinese Name: 白杨
> Nick Name: Hamo
> Homepage: http://hamobai.com/
> GPG KEY ID: 0xA4691A33
> Key fingerprint = 09D5 2D78 8E2B 0995 CF8E  4331 33C4 3D24 A469 1A33



-- 
    """
    Keep It Simple,Stupid.
    """

Chinese Name: 白杨
Nick Name: Hamo
Homepage: http://hamobai.com/
GPG KEY ID: 0xA4691A33
Key fingerprint = 09D5 2D78 8E2B 0995 CF8E  4331 33C4 3D24 A469 1A33
