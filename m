Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbaKMNdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:33:06 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49927 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681AbaKMNdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:33:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAFp+6iGAQMgX8S6dfPO44U=r6QJ4fT+1FX2uHNF9KK4sYs+=XA@mail.gmail.com>
References: <1413556756-5050-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1413556756-5050-3-git-send-email-heikki.krogerus@linux.intel.com>
	<CAFp+6iH2oPT-HyJhFCXVCL4eUOQ0AFfxuyGsnXzPv9JTo55+VQ@mail.gmail.com>
	<5461AFD3.5020302@ti.com>
	<CAFp+6iGJBSpA5+Q7WQVu0+y-mfoN-E+LmYedipVfgXFZOpr+Cw@mail.gmail.com>
	<5461CDDF.4090209@ti.com>
	<CAFp+6iGAQMgX8S6dfPO44U=r6QJ4fT+1FX2uHNF9KK4sYs+=XA@mail.gmail.com>
Date: Thu, 13 Nov 2014 19:03:01 +0530
Message-ID: <CAFp+6iHta15CuBbsoQxEo2xr5GyXDgXQ=cg_Q_vOSC7akX0Vcw@mail.gmail.com>
Subject: Re: [PATCHv4 2/6] phy: improved lookup method
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        andrew.kim@intel.com
Content-Type: multipart/mixed; boundary=001a11339b582a07b70507bd8db2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11339b582a07b70507bd8db2
Content-Type: text/plain; charset=UTF-8

Hi Heikki, Kishon,


On Tue, Nov 11, 2014 at 2:23 PM, Vivek Gautam <gautamvivek1987@gmail.com> wrote:
> Hi Kishon,
>
>
> On Tue, Nov 11, 2014 at 2:20 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> Hi,
>>
>> On Tuesday 11 November 2014 02:07 PM, Vivek Gautam wrote:
>>> On Tue, Nov 11, 2014 at 12:12 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>>>> Hi,
>>>>
>>>> On Friday 31 October 2014 06:03 PM, Vivek Gautam wrote:
>>>>> Hi Heikki,
>>>>>
>>>>>
>>>>> On Fri, Oct 17, 2014 at 8:09 PM, Heikki Krogerus
>>>>> <heikki.krogerus@linux.intel.com> wrote:
>>>>>> Removes the need for the phys to be aware of their users
>>>>>> even when not using DT. The method is copied from clkdev.c.
>>>>>>
>>>>>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>>>>> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
>>>>>> ---
>>>>>>  Documentation/phy.txt   |  66 ++++++++---------------
>>>>>>  drivers/phy/phy-core.c  | 135 +++++++++++++++++++++++++++++++++++++++++++++++-
>>>>>>  include/linux/phy/phy.h |  27 ++++++++++
>>>>>>  3 files changed, 183 insertions(+), 45 deletions(-)
>>>>>>
>>>>>> diff --git a/Documentation/phy.txt b/Documentation/phy.txt
>>>>>> index c6594af..8add515 100644
>>>>>> --- a/Documentation/phy.txt
>>>>>> +++ b/Documentation/phy.txt
>>>>>> @@ -54,18 +54,14 @@ The PHY driver should create the PHY in order for other peripheral controllers
>>>>>>  to make use of it. The PHY framework provides 2 APIs to create the PHY.
>>>>>>
>>>>>>  struct phy *phy_create(struct device *dev, struct device_node *node,
>>>>>> -                      const struct phy_ops *ops,
>>>>>> -                      struct phy_init_data *init_data);
>>>>>> +                      const struct phy_ops *ops);
>>>>>>  struct phy *devm_phy_create(struct device *dev, struct device_node *node,
>>>>>> -                           const struct phy_ops *ops,
>>>>>> -                           struct phy_init_data *init_data);
>>>>>> +                           const struct phy_ops *ops);
>>>>>>
>>>>>>  The PHY drivers can use one of the above 2 APIs to create the PHY by passing
>>>>>> -the device pointer, phy ops and init_data.
>>>>>> +the device pointer and phy ops.
>>>>>>  phy_ops is a set of function pointers for performing PHY operations such as
>>>>>> -init, exit, power_on and power_off. *init_data* is mandatory to get a reference
>>>>>> -to the PHY in the case of non-dt boot. See section *Board File Initialization*
>>>>>> -on how init_data should be used.
>>>>>> +init, exit, power_on and power_off.
>>>>>>
>>>>>>  Inorder to dereference the private data (in phy_ops), the phy provider driver
>>>>>>  can use phy_set_drvdata() after creating the PHY and use phy_get_drvdata() in
>>>>>> @@ -137,42 +133,24 @@ There are exported APIs like phy_pm_runtime_get, phy_pm_runtime_get_sync,
>>>>>>  phy_pm_runtime_put, phy_pm_runtime_put_sync, phy_pm_runtime_allow and
>>>>>>  phy_pm_runtime_forbid for performing PM operations.
>>>>>>
>>>>>> -8. Board File Initialization
>>>>>> -
>>>>>> -Certain board file initialization is necessary in order to get a reference
>>>>>> -to the PHY in the case of non-dt boot.
>>>>>> -Say we have a single device that implements 3 PHYs that of USB, SATA and PCIe,
>>>>>> -then in the board file the following initialization should be done.
>>>>>> -
>>>>>> -struct phy_consumer consumers[] = {
>>>>>> -       PHY_CONSUMER("dwc3.0", "usb"),
>>>>>> -       PHY_CONSUMER("pcie.0", "pcie"),
>>>>>> -       PHY_CONSUMER("sata.0", "sata"),
>>>>>> -};
>>>>>> -PHY_CONSUMER takes 2 parameters, first is the device name of the controller
>>>>>> -(PHY consumer) and second is the port name.
>>>>>> -
>>>>>> -struct phy_init_data init_data = {
>>>>>> -       .consumers = consumers,
>>>>>> -       .num_consumers = ARRAY_SIZE(consumers),
>>>>>> -};
>>>>>> -
>>>>>> -static const struct platform_device pipe3_phy_dev = {
>>>>>> -       .name = "pipe3-phy",
>>>>>> -       .id = -1,
>>>>>> -       .dev = {
>>>>>> -               .platform_data = {
>>>>>> -                       .init_data = &init_data,
>>>>>> -               },
>>>>>> -       },
>>>>>> -};
>>>>>> -
>>>>>> -then, while doing phy_create, the PHY driver should pass this init_data
>>>>>> -       phy_create(dev, ops, pdata->init_data);
>>>>>> -
>>>>>> -and the controller driver (phy consumer) should pass the port name along with
>>>>>> -the device to get a reference to the PHY
>>>>>> -       phy_get(dev, "pcie");
>>>>>> +8. PHY Mappings
>>>>>> +
>>>>>> +In order to get reference to a PHY without help from DeviceTree, the framework
>>>>>> +offers lookups which can be compared to clkdev that allow clk structures to be
>>>>>> +bound to devices. A lookup can be made statically by directly registering
>>>>>> +phy_lookup structure which contains the name of the PHY device, the name of the
>>>>>> +device which the PHY will be bind to and Connection ID string. Alternatively a
>>>>>> +lookup can be made during runtime when a handle to the struct phy already
>>>>>> +exists.
>>>>>> +
>>>>>> +The framework offers the following APIs for registering and unregistering the
>>>>>> +lookups.
>>>>>> +
>>>>>> +void phy_register_lookup(struct phy_lookup *pl);
>>>>>> +int phy_create_lookup(struct phy *phy, const char *con_id, const char *dev_id);
>>>>>> +
>>>>>> +void phy_unregister_lookup(struct phy_lookup *pl);
>>>>>> +void phy_remove_lookup(struct phy *phy, const char *con_id, const char *dev_id);
>>>>>>
>>>>>>  9. DeviceTree Binding
>>>>>>
>>>>>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>>>>>> index ff5eec5..c8d0f66 100644
>>>>>> --- a/drivers/phy/phy-core.c
>>>>>> +++ b/drivers/phy/phy-core.c
>>>>>> @@ -26,6 +26,7 @@
>>>>>>  static struct class *phy_class;
>>>>>>  static DEFINE_MUTEX(phy_provider_mutex);
>>>>>>  static LIST_HEAD(phy_provider_list);
>>>>>> +static LIST_HEAD(phys);
>>>>>>  static DEFINE_IDA(phy_ida);
>>>>>>
>>>>>>  static void devm_phy_release(struct device *dev, void *res)
>>>>>> @@ -84,6 +85,138 @@ static struct phy *phy_lookup(struct device *device, const char *port)
>>>>>>         return ERR_PTR(-ENODEV);
>>>>>>  }
>>>>>>
>>>>>> +/**
>>>>>> + * phy_register_lookup() - register PHY/device association
>>>>>> + * @pl: association to register
>>>>>> + */
>>>>>> +void phy_register_lookup(struct phy_lookup *pl)
>>>>>> +{
>>>>>> +       mutex_lock(&phy_provider_mutex);
>>>>>> +       list_add_tail(&pl->node, &phys);
>>>>>> +       mutex_unlock(&phy_provider_mutex);
>>>>>> +}
>>>>>> +
>>>>>> +/**
>>>>>> + * phy_unregister_lookup() - remove PHY/device association
>>>>>> + * @pl: association to be removed
>>>>>> + */
>>>>>> +void phy_unregister_lookup(struct phy_lookup *pl)
>>>>>> +{
>>>>>> +       mutex_lock(&phy_provider_mutex);
>>>>>> +       list_del(&pl->node);
>>>>>> +       mutex_unlock(&phy_provider_mutex);
>>>>>> +}
>>>>>> +
>>>>>> +/**
>>>>>> + * phy_create_lookup() - allocate and register PHY/device association
>>>>>> + * @phy: the phy of the association
>>>>>> + * @con_id: connection ID string on device
>>>>>> + * @dev_id: the device of the association
>>>>>> + *
>>>>>> + * Creates and registers phy_lookup entry.
>>>>>> + */
>>>>>> +int phy_create_lookup(struct phy *phy, const char *con_id, const char *dev_id)
>>>>>> +{
>>>>>> +       struct phy_lookup *pl;
>>>>>> +
>>>>>> +       if (!phy || (!dev_id && !con_id))
>>>>>> +               return -EINVAL;
>>>>>> +
>>>>>> +       pl = kzalloc(sizeof(*pl), GFP_KERNEL);
>>>>>> +       if (!pl)
>>>>>> +               return -ENOMEM;
>>>>>> +
>>>>>> +       pl->phy_name = dev_name(phy->dev.parent);
>>>>>> +       pl->dev_id = dev_id;
>>>>>> +       pl->con_id = con_id;
>>>>>> +
>>>>>> +       phy_register_lookup(pl);
>>>>>> +
>>>>>> +       return 0;
>>>>>> +}
>>>>>> +EXPORT_SYMBOL_GPL(phy_create_lookup);
>>>>>> +
>>>>>> +/**
>>>>>> + * phy_remove_lookup() - find and remove PHY/device association
>>>>>> + * @phy: the phy of the association
>>>>>> + * @con_id: connection ID string on device
>>>>>> + * @dev_id: the device of the association
>>>>>> + *
>>>>>> + * Finds and unregisters phy_lookup entry that was created with
>>>>>> + * phy_create_lookup().
>>>>>> + */
>>>>>> +void phy_remove_lookup(struct phy *phy, const char *con_id, const char *dev_id)
>>>>>> +{
>>>>>> +       struct phy_lookup *pl;
>>>>>> +
>>>>>> +       if (!phy || (!dev_id && !con_id))
>>>>>> +               return;
>>>>>> +
>>>>>> +       list_for_each_entry(pl, &phys, node)
>>>>>> +               if (!strcmp(pl->phy_name, dev_name(phy->dev.parent)) &&
>>>>>> +                   !strcmp(pl->dev_id, dev_id) &&
>>>>>> +                   !strcmp(pl->con_id, con_id)) {
>>>>>> +                       phy_unregister_lookup(pl);
>>>>>> +                       kfree(pl);
>>>>>> +                       return;
>>>>>> +               }
>>>>>> +}
>>>>>> +EXPORT_SYMBOL_GPL(phy_remove_lookup);
>>>>>> +
>>>>>> +static struct phy *phy_find(struct device *dev, const char *con_id)
>>>>>> +{
>>>>>> +       const char *dev_id = dev ? dev_name(dev) : NULL;
>>>>>> +       int match, best_found = 0, best_possible = 0;
>>>>>> +       struct phy *phy = ERR_PTR(-ENODEV);
>>>>>> +       struct phy_lookup *p, *pl = NULL;
>>>>>> +
>>>>>> +       if (dev_id)
>>>>>> +               best_possible += 2;
>>>>>> +       if (con_id)
>>>>>> +               best_possible += 1;
>>>>>> +
>>>>>> +       list_for_each_entry(p, &phys, node) {
>>>>>> +               match = 0;
>>>>>> +               if (p->dev_id) {
>>>>>> +                       if (!dev_id || strcmp(p->dev_id, dev_id))
>>>>>> +                               continue;
>>>>>> +                       match += 2;
>>>>>> +               }
>>>>>> +               if (p->con_id) {
>>>>>> +                       if (!con_id || strcmp(p->con_id, con_id))
>>>>>> +                               continue;
>>>>>> +                       match += 1;
>>>>>> +               }
>>>>>> +
>>>>>> +               if (match > best_found) {
>>>>>> +                       pl = p;
>>>>>> +                       if (match != best_possible)
>>>>>> +                               best_found = match;
>>>>>> +                       else
>>>>>> +                               break;
>>>>>> +               }
>>>>>> +       }
>>>>>> +
>>>>>> +       if (pl) {
>>>>>> +               struct class_dev_iter iter;
>>>>>> +               struct device *phy_dev;
>>>>>> +
>>>>>> +               class_dev_iter_init(&iter, phy_class, NULL, NULL);
>>>>>> +               while ((phy_dev = class_dev_iter_next(&iter))) {
>>>>>
>>>>> We have the case with phy-exynos5-usbdrd driver, which registers two
>>>>> phys usb2-phy and usb3-phy
>>>>> both being used by xhci (after dwc3 creates a lookup table).
>>>>>
>>>>> The phy_dev is coming same for both the PHYs, and that's the reason
>>>>> when i try to get
>>>>> "usb2-phy" and "usb3-phy" i end up getting only usb2-phy.
>>>>> This is happening with V4 of this patch; V3 seems fine. The only
>>>>> differnece i see is
>>>>> we are creating the phy_lookup_table using phy_dev->parent.
>>>>>
>>>>> Is there something that i am missing ?
>>>>
>>>> looks like a genuine problem.
>>>>>
>>>>>> +                       if (!strcmp(dev_name(phy_dev->parent), pl->phy_name)) {
>>>>
>>>> here there are two phys which has the same parent and the first one that
>>>> matches will be returned. Hence you always get "usb2-phy".
>>>>
>>>> IIUC just with device names of parent, we won't be able to get the PHY. We need
>>>> another 'variable' to differentiate it's children.
>>>
>>>> Or have *phy* pointer directly in the lookup table like how clk driver does?
>>>
>>> We do create the lookup table with actual *phy* pointer isn't it ?
>>> Like if you see Heikki's last patch in this series:
>>> [PATCHv4 6/6] usb: dwc3: host: convey the PHYs to xhci
>>> We do pass the usb2_phy and usb3_phy pointers to phy_create_lookup().
>>
>> right, but phy_create_lookup doesn't store the *phy* pointer in the lookup table.
>
> Right, so i think that's the place where we should rework to get the
> correct phy.

How about adding the change in attached patch [1] on top of this patch.
Just introduced the phy pointer in "phy_lookup" structure, and
modified phy_find() accordingly.

[1] Attachment:
    0001-phy-core-Use-phy-pointer-with-phy_lookup_table.patch



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India

--001a11339b582a07b70507bd8db2
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-phy-core-Use-phy-pointer-with-phy_lookup_table.patch"
Content-Disposition: attachment; 
	filename="0001-phy-core-Use-phy-pointer-with-phy_lookup_table.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2g5lx9y0

RnJvbSA4NDhlNjkxY2YzNmEwMzlmN2E3Y2VmYWMxMWRmNDkyMzBjNzFlODA2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBWaXZlayBHYXV0YW0gPGdhdXRhbS52aXZla0BzYW1zdW5nLmNv
bT4KRGF0ZTogVGh1LCAxMyBOb3YgMjAxNCAxODozMzo1MSArMDUzMApTdWJqZWN0OiBbUEFUQ0gg
UkZDXSBwaHk6IGNvcmU6IFVzZSBwaHkgcG9pbnRlciB3aXRoIHBoeV9sb29rdXBfdGFibGUKClNp
Z25lZC1vZmYtYnk6IFZpdmVrIEdhdXRhbSA8Z2F1dGFtLnZpdmVrQHNhbXN1bmcuY29tPgotLS0K
CiBkcml2ZXJzL3BoeS9waHktY29yZS5jICB8ICAgMzEgKysrKysrKysrLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQogaW5jbHVkZS9saW51eC9waHkvcGh5LmggfCAgICAxICsKIDIgZmlsZXMgY2hhbmdl
ZCwgMTAgaW5zZXJ0aW9ucygrKSwgMjIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9waHkvcGh5LWNvcmUuYyBiL2RyaXZlcnMvcGh5L3BoeS1jb3JlLmMKaW5kZXggMGIyNzlkMy4u
YTRhNjdlMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9waHkvcGh5LWNvcmUuYworKysgYi9kcml2ZXJz
L3BoeS9waHktY29yZS5jCkBAIC05OSw2ICs5OSw3IEBAIGludCBwaHlfY3JlYXRlX2xvb2t1cChz
dHJ1Y3QgcGh5ICpwaHksIGNvbnN0IGNoYXIgKmNvbl9pZCwgY29uc3QgY2hhciAqZGV2X2lkKQog
CXBsLT5waHlfbmFtZSA9IGRldl9uYW1lKHBoeS0+ZGV2LnBhcmVudCk7CiAJcGwtPmRldl9pZCA9
IGRldl9pZDsKIAlwbC0+Y29uX2lkID0gY29uX2lkOworCXBsLT5waHkJPSBwaHk7CiAKIAlwaHlf
cmVnaXN0ZXJfbG9va3VwKHBsKTsKIApAQCAtMTY3LDE4ICsxNjgsMTAgQEAgc3RhdGljIHN0cnVj
dCBwaHkgKnBoeV9maW5kKHN0cnVjdCBkZXZpY2UgKmRldiwgY29uc3QgY2hhciAqY29uX2lkKQog
CQl9CiAJfQogCi0JaWYgKHBsKSB7Ci0JCXN0cnVjdCBjbGFzc19kZXZfaXRlciBpdGVyOwotCQlz
dHJ1Y3QgZGV2aWNlICpwaHlfZGV2OwotCi0JCWNsYXNzX2Rldl9pdGVyX2luaXQoJml0ZXIsIHBo
eV9jbGFzcywgTlVMTCwgTlVMTCk7Ci0JCXdoaWxlICgocGh5X2RldiA9IGNsYXNzX2Rldl9pdGVy
X25leHQoJml0ZXIpKSkgewotCQkJaWYgKCFzdHJjbXAoZGV2X25hbWUocGh5X2Rldi0+cGFyZW50
KSwgcGwtPnBoeV9uYW1lKSkgewotCQkJCXBoeSA9IHRvX3BoeShwaHlfZGV2KTsKLQkJCQlicmVh
azsKLQkJCX0KLQkJfQotCQljbGFzc19kZXZfaXRlcl9leGl0KCZpdGVyKTsKKwlpZiAocGwgJiYg
cGwtPnBoeSkgeworCQlwaHkgPSBwbC0+cGh5OworCQlpZiAoIXRyeV9tb2R1bGVfZ2V0KHBoeS0+
b3BzLT5vd25lcikpCisJCQlwaHkgPSBFUlJfUFRSKC1FUFJPQkVfREVGRVIpOwogCX0KIAlyZXR1
cm4gcGh5OwogfQpAQCAtNTQ5LDcgKzU0Miw2IEBAIEVYUE9SVF9TWU1CT0xfR1BMKG9mX3BoeV9z
aW1wbGVfeGxhdGUpOwogICovCiBzdHJ1Y3QgcGh5ICpwaHlfZ2V0KHN0cnVjdCBkZXZpY2UgKmRl
diwgY29uc3QgY2hhciAqc3RyaW5nKQogewotCWludCBpbmRleCA9IDA7CiAJc3RydWN0IHBoeSAq
cGh5OwogCiAJaWYgKHN0cmluZyA9PSBOVUxMKSB7CkBAIC01NTcsMTkgKzU0OSwxNCBAQCBzdHJ1
Y3QgcGh5ICpwaHlfZ2V0KHN0cnVjdCBkZXZpY2UgKmRldiwgY29uc3QgY2hhciAqc3RyaW5nKQog
CQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsKIAl9CiAKLQlpZiAoZGV2LT5vZl9ub2RlKSB7Ci0J
CWluZGV4ID0gb2ZfcHJvcGVydHlfbWF0Y2hfc3RyaW5nKGRldi0+b2Zfbm9kZSwgInBoeS1uYW1l
cyIsCi0JCQlzdHJpbmcpOwotCQlwaHkgPSBfb2ZfcGh5X2dldChkZXYtPm9mX25vZGUsIGluZGV4
KTsKLQl9IGVsc2UgeworCWlmIChkZXYtPm9mX25vZGUpCisJCXBoeSA9IG9mX3BoeV9nZXQoZGV2
LT5vZl9ub2RlLCBzdHJpbmcpOworCWVsc2UKIAkJcGh5ID0gcGh5X2ZpbmQoZGV2LCBzdHJpbmcp
OwotCX0KKwogCWlmIChJU19FUlIocGh5KSkKIAkJcmV0dXJuIHBoeTsKIAotCWlmICghdHJ5X21v
ZHVsZV9nZXQocGh5LT5vcHMtPm93bmVyKSkKLQkJcmV0dXJuIEVSUl9QVFIoLUVQUk9CRV9ERUZF
Uik7Ci0KIAlnZXRfZGV2aWNlKCZwaHktPmRldik7CiAKIAlyZXR1cm4gcGh5OwpkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC9waHkvcGh5LmggYi9pbmNsdWRlL2xpbnV4L3BoeS9waHkuaAppbmRl
eCBkOTgzMDUxLi40YjIxZDcyIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L3BoeS9waHkuaAor
KysgYi9pbmNsdWRlL2xpbnV4L3BoeS9waHkuaApAQCAtODgsNiArODgsNyBAQCBzdHJ1Y3QgcGh5
X2xvb2t1cCB7CiAJY29uc3QgY2hhciAqcGh5X25hbWU7CiAJY29uc3QgY2hhciAqZGV2X2lkOwog
CWNvbnN0IGNoYXIgKmNvbl9pZDsKKwlzdHJ1Y3QgcGh5ICpwaHk7CiB9OwogCiAjZGVmaW5lIFBI
WV9MT09LVVAoYSwgYiwgYykJXAotLSAKMS43LjEwLjQKCg==
--001a11339b582a07b70507bd8db2--
