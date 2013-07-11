Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3GKU4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 16:56:03 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:46094 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624Ab3GKU4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:56:01 -0400
Message-ID: <51DF1BDD.6080707@schinagl.nl>
Date: Thu, 11 Jul 2013 22:55:57 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130613 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux@roeck-us.net, khali@linux-fr.org
Subject: Re: [PATCH v2 2/7] sysfs.h: add ATTRIBUTE_GROUPS() macro
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org> <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org> <1373502965-1683-3-git-send-email-gregkh@linuxfoundation.org> <51DE9DE5.20905@schinagl.nl> <20130711170648.GC23056@kroah.com> <51DF10E7.5070901@schinagl.nl> <20130711202617.GA25003@kroah.com>
In-Reply-To: <20130711202617.GA25003@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------030909080803050605030402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030909080803050605030402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/11/13 22:26, Greg Kroah-Hartman wrote:
> On Thu, Jul 11, 2013 at 10:09:11PM +0200, Oliver Schinagl wrote:
>> On 07/11/13 19:06, Greg Kroah-Hartman wrote:
>>> On Thu, Jul 11, 2013 at 01:58:29PM +0200, Oliver Schinagl wrote:
>>>> On 11-07-13 02:36, Greg Kroah-Hartman wrote:
>>>>> To make it easier for driver subsystems to work with attribute groups,
>>>>> create the ATTRIBUTE_GROUPS macro to remove some of the repetitive
>>>>> typing for the most common use for attribute groups.
>>>> But binary groups are discriminated against :(
>>>
>>> Yes, as they are "rarer" by far, as they should be.  binary sysfs files
>>> should almost never be used, as they are only "pass-through" files to
>>> the hardware, so I want to see you do more work in order to use them, as
>>> they should not be created lightly.
>> I guess I can see a valid reason here, but they are only helper
>> macro's making life easier for people who do need to use these and
>> are on par with the non-binary versions. And we already have quite
>> some binary attributes, probably far less then normal ones :)
>
> I only count about 100 valid binary files in the tree at the moment,
> that's not really all that many to handle.
100 is quite a few :) But point taken.
>
>> Anyway, wouldn't all users be reviewed anyway? But I guess it's a
>> small safety net to make it not TOO easy.
>
> exactly :)
I aggree and this is a v2 that strips all the additional bits.

A few comments left below.

>
>>>> The attached patch should help here.
>>>
>>> Can you give me an example of using these macros?  I seem to be lost in
>>> them somehow, or maybe my morning coffee just hasn't kicked in...
>> Yeah, I kinda added the whole shebang there :) I was trying being helpful :(
>>
>>>
>>>> I suppose one more additional helper wouldn't be bad to have:
>>>>
>>>> #define ATTRIBUTE_(BIN_)GROUPS_R[O/W](_name(, _size)) \
>>>> ATTRIBUTE_(BIN_)ATTR_R[O/W](_name, _size); \
>>>> ATTRIBUTE_(BIN_)GROUPS(_name)
>>>
>>> Would that ever be needed?
>> Of ourse, by the lazy :)
>>
>> I think now you create an attribute in a group as this (with this patch):
>>
>> ATTRIBUTE_ATTR_RO(name, SIZE);
>
> but "raw" attributes are rare, you really want a "device", "class", or
> "bus" attribute, right?
I suppose so, But I got stuck in the rare case some how initially. I 
registered my driver with module_platform_driver(); and in that struct i 
had the "device_driver" which had a group attribute so I used that. I 
already learned from maxime that that is the wrong way :) and hopefully 
I'll figure out what the right way will be soon ;)

>
>> ATTRIBUTE_GROUPS(name);
>>
>> .group = name;
>>
>> After that last addition, you'd simply do:
>> ATTRIBUTE_GROUPS_RO(name);
>>
>> .group = name;
>>
>> saves a whole line :)
>
> Not worth it :)
>
>>>> >From 003ab7a74ff689daa6934e7bc50c498b2d35a1cc Mon Sep 17 00:00:00 2001
>>>> From: Oliver Schinagl <oliver@schinagl.nl>
>>>> Date: Thu, 11 Jul 2013 13:48:18 +0200
>>>> Subject: [PATCH] sysfs: add more helper macro's for (bin_)attribute(_groups)
>>>>
>>>> With the recent changes to sysfs there's various helper macro's.
>>>> However there's no RW, RO BIN_ helper macro's. This patch adds them.
>>>>
>>>> Additionally there are no BIN_ group helpers so there's that aswell
>>>> Moreso, if both bin and normal attribute groups are used, there's a
>>>> simple helper for that, though the naming code be better. _TXT_ for the
>>>> show/store ones and neither TXT or BIN for both, but that would change
>>>> things to extensivly.
>>>>
>>>> Finally there's also helpers for ATTRIBUTE_ATTRS.
>>>>
>>>> After this patch, create default attributes can be as easy as:
>>>>
>>>> ATTRIBUTE_(BIN_)ATTR_RO(name, SIZE);
>>>> ATTRIBUTE_BIN_GROUPS(name);
>>>>
>>>> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
>>>> ---
>>>>   include/linux/sysfs.h | 96 ++++++++++++++++++++++++++++++++++++++++++++-------
>>>>   1 file changed, 84 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
>>>> index 2c3b6a3..0ebed11 100644
>>>> --- a/include/linux/sysfs.h
>>>> +++ b/include/linux/sysfs.h
>>>> @@ -17,6 +17,7 @@
>>>>   #include <linux/list.h>
>>>>   #include <linux/lockdep.h>
>>>>   #include <linux/kobject_ns.h>
>>>> +#include <linux/stat.h>
>>>>   #include <linux/atomic.h>
>>>>
>>>>   struct kobject;
>>>> @@ -94,15 +95,32 @@ struct attribute_group {
>>>>   #define __ATTR_IGNORE_LOCKDEP	__ATTR
>>>>   #endif
>>>>
>>>> -#define ATTRIBUTE_GROUPS(name)					\
>>>> -static const struct attribute_group name##_group = {		\
>>>> -	.attrs = name##_attrs,					\
>>>> +#define __ATTRIBUTE_GROUPS(_name)				\
>>>> +static const struct attribute_group *_name##_groups[] = {	\
>>>> +	&_name##_group,						\
>>>> +	NULL,							\
>>>> +}
>>>> +
>>>> +#define ATTRIBUTE_GROUPS(_name)					\
>>>> +static const struct attribute_group _name##_group = {		\
>>>> +	.attrs = _name##_attrs,					\
>>>>   };								\
>>>> -static const struct attribute_group *name##_groups[] = {	\
>>>> -	&name##_group,						\
>>>> +__ATTRIBUTE_GROUPS(_name)
>>>> +
>>>> +#define __ATTRIBUTE_ATTRS(_name)				\
>>>> +struct bin_attribute *_name##_attrs[] = {			\
>> typo here, scrap bin_ copy paste fail!
>>
>>>> +	&_name##_attr,						\
>>>>   	NULL,							\
>>>>   }
>>>>
>>>> +#define ATTRIBUTE_ATTR_RO(_name, _size)				\
>>>> +struct attribute _name##_attr = __ATTR_RO(_name, _size);	\
>>>> +__ATTRIBUTE_ATTRS(_name)
>>>> +
>>>> +#define ATTRIBUTE_ATTR_RW(_name, _size)				\
>>>> +struct attribute _name##_attr = __ATTR_RW(_name, _size);	\
>>>> +__ATTRIBUTE_ATTRS(_name)
>>>
>>> What do these two help out with?  "attribute attribute read-write" seems
>>> a bit "clunky", don't you think? :)
>> I aggree, but I tried to stick with the ATTRIBUTE_GROUP naming and
>> that's the best I could come up with.
>>
>> Unless I completely misunderstood (which isn't all that unlikely)
>> the following is needed to create a group using a .group.
>>
>> So you pass group an array of attribute_group pointers. The
>> ATTRIBUTE_GROUPS helps there, right? It saves the typing of creating
>> the array of groups and adding groups to that.
>>
>> So a group consists of an array of attributes if I understood right
>> and that array needs to be filled with pointers attributes? well
>> those ATTRIBUTE_ATTR's do just that. Granted, maybe the naming is
>> poor, but just ATTRS() felt to short.
>
> Here's an example of a file I converted to use the ATTRIBUTE_GROUP()
> macro attached below (net/wireless/sysfs).  As is, it's an increase of
> only 2 lines to the file overall, which is about normal for the
> conversion.  As you can see, you still need a list of attributes (which
> someone has already said I need another macro for, to stop typing
> "&dev_attr*.attr" all the time).
>
> With your macros, how would a file be converted to use them?  Perhaps
> that will help explain things to me better.
Heh, they can't I don't think.

>
>
>>>> +#define ATTRIBUTE_BIN_GROUPS(_name)					\
>>>> +static const struct attribute_group _name##_bin_group = {		\
>>>> +	.bin_attrs = _name##_bin_attrs,					\
>>>> +};									\
>>>> +__ATTRIBUTE_BIN_GROUPS(_name)
>> This is the equiv. of ATTRIBUTE_GROUPS(_name) which creates an
>> attribute group, with only a binary attribute instead.
>
> Again, binary files are rare, and should be rare, don't make it too easy
> to create them :)
>
>>>> +#define ATTRIBUTE_BIN_ATTR_RW(_name, _size)				\
>>>> +struct bin_attribute _name##_bin_attr = __BIN_ATTR_RW(_name, _size);	\
>>>> +__ATTRIBUTE_BIN_ATTRS(_name)
>> These I guess are the equivialent what ATTRIBUTE_GROUP is for
>> groups, but now for the attributes that go in groups?
>>
>>>
>>> Can you show me how these would be used in a real-world example?
>> Well my real world is currently limited by my own driver. If I may
>> copy paste from there:
>>
>> ATTRIBUTE_BIN_ATTR_RO(sunxi_sid, SID_SIZE);
>> ATTRIBUTE_BIN_GROUPS(sunxi_sid);
>>
>> static struct platform_driver sunxi_sid_driver = {
>> 	.probe = sunxi_sid_probe,
>> 	.remove = sunxi_sid_remove,
>> 	.driver = {
>> 		.name = DRV_NAME,
>> 		.owner = THIS_MODULE,
>> 		.of_match_table = sunxi_sid_of_match,
>> 		.groups = sunxi_sid_bin_groups,
>> 	},
>> };
>> module_platform_driver(sunxi_sid_driver);
>>
>> But if you say, you want to be a little less complete, we can drop
>> ATTRIBUTE_BIN_ATTR_R[OW]() forcing you to do this instead:
>>
>> struct bin_attribute sunxi_sid_bin_attr = __BIN_ATTR_RO(eeprom, SID_SIZE);
>>
>> struct bin_attribute *sunxi_sid_bin_attrs[] = {
>> 	&sunxi_sid_bin_attr,
>> 	NULL,
>> };
>>
>> Which requires some manual labor yet still has the __BIN_ATTR_R[OW]
>> macro's to help with some of the more tedious work and allowing you
>> to name the binary attributes nicer?
>
> BIN_ATTR_RO() is fine, I'd stick with that for now, it's getting
> confusing enough as-is :)
Agreed and attached.

>
> thanks,
>
> greg k-h
>


--------------030909080803050605030402
Content-Type: text/x-patch;
 name="0001-sysfs-add-more-helper-macro-s-for-bin_-attribute-_gr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-sysfs-add-more-helper-macro-s-for-bin_-attribute-_gr.pa";
 filename*1="tch"

>From 669597be47d042ee28abe5f7e172054043b003e7 Mon Sep 17 00:00:00 2001
From: Oliver Schinagl <oliver@schinagl.nl>
Date: Thu, 11 Jul 2013 13:48:18 +0200
Subject: [PATCH 1/2] sysfs: add more helper macro's for
 (bin_)attribute(_groups)

With the recent changes to sysfs there's various helper macro's.
However there's no RW, RO BIN_ helper macro's. This patch adds them.

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
---
 include/linux/sysfs.h | 51 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 2c3b6a3..5cf502f 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -17,6 +17,7 @@
 #include <linux/list.h>
 #include <linux/lockdep.h>
 #include <linux/kobject_ns.h>
+#include <linux/stat.h>
 #include <linux/atomic.h>
 
 struct kobject;
@@ -94,15 +95,18 @@ struct attribute_group {
 #define __ATTR_IGNORE_LOCKDEP	__ATTR
 #endif
 
-#define ATTRIBUTE_GROUPS(name)					\
-static const struct attribute_group name##_group = {		\
-	.attrs = name##_attrs,					\
-};								\
-static const struct attribute_group *name##_groups[] = {	\
-	&name##_group,						\
+#define __ATTRIBUTE_GROUPS(_name)				\
+static const struct attribute_group *_name##_groups[] = {	\
+	&_name##_group,						\
 	NULL,							\
 }
 
+#define ATTRIBUTE_GROUPS(_name)					\
+static const struct attribute_group _name##_group = {		\
+	.attrs = _name##_attrs,					\
+};								\
+__ATTRIBUTE_GROUPS(_name)
+
 #define attr_name(_attr) (_attr).attr.name
 
 struct file;
@@ -132,15 +136,36 @@ struct bin_attribute {
  */
 #define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&(bin_attr)->attr)
 
-/* macro to create static binary attributes easier */
-#define BIN_ATTR(_name, _mode, _read, _write, _size)		\
-struct bin_attribute bin_attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.read	= _read,					\
-	.write	= _write,					\
-	.size	= _size,					\
+/* macros to create static binary attributes easier */
+#define __BIN_ATTR(_name, _mode, _read, _write, _size) {		\
+	.attr = { .name = __stringify(_name), .mode = _mode },		\
+	.read	= _read,						\
+	.write	= _write,						\
+	.size	= _size,						\
+}
+
+#define __BIN_ATTR_RO(_name, _size) {					\
+	.attr	= { .name = __stringify(_name), .mode = S_IRUGO },	\
+	.read	= _name##_read,						\
+	.size	= _size,						\
 }
 
+#define __BIN_ATTR_RW(_name, _size) __BIN_ATTR(_name,			\
+				   (S_IWUSR | S_IRUGO), _name##_read,	\
+				   _name##_write)
+
+#define __BIN_ATTR_NULL __ATTR_NULL
+
+#define BIN_ATTR(_name, _mode, _read, _write, _size)			\
+struct bin_attribute bin_attr_##_name = __BIN_ATTR(_name, _mode, _read,	\
+					_write, _size)
+
+#define BIN_RO_ATTR(_name, _size)					\
+struct bin_attribute bin_attr_##_name = __BIN_ATTR_RO(_name, _size)
+
+#define BIN_RW_ATTR(_name, _size)					\
+struct bin_attribute bin_attr_##_name = __BIN_ATTR_RW(_name, _size)
+
 struct sysfs_ops {
 	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
-- 
1.8.1.5


--------------030909080803050605030402--
