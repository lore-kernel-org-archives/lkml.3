Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3H0J0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:26:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64032 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab3H0J0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:26:05 -0400
X-IronPort-AV: E=Sophos;i="4.89,967,1367942400"; 
   d="scan'208,223";a="8316923"
Message-ID: <521C6FA8.4070804@cn.fujitsu.com>
Date: Tue, 27 Aug 2013 17:21:44 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] driver core / ACPI: Avoid device removal locking problems
References: <1543475.L7gSB7lLAu@vostro.rjw.lan> <4785337.sqQqDSPcpL@vostro.rjw.lan> <3389643.Fdir3g6c6B@vostro.rjw.lan> <1430120.G7JdUKlgj6@vostro.rjw.lan>
In-Reply-To: <1430120.G7JdUKlgj6@vostro.rjw.lan>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/27 17:24:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/27 17:24:06
Content-Type: multipart/mixed;
 boundary="------------070907000804050000010406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------070907000804050000010406
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

Hi Rafael,

On 08/26/2013 11:02 PM, Rafael J. Wysocki wrote:

> On Monday, August 26, 2013 04:43:26 PM Rafael J. Wysocki wrote:
>> On Monday, August 26, 2013 02:42:09 PM Rafael J. Wysocki wrote:
>>> On Monday, August 26, 2013 11:13:13 AM Gu Zheng wrote:
>>>> Hi Rafael,
> 
> [...]
> 
>>
>> OK, so the patch below is quick and dirty and overkill, but it should make the
>> splat go away at least.
> 
> And if this patch does make the splat go away for you, please also test the
> appended one (Tejun, thanks for the hint!).
> 
> I'll address the ACPI part differently later.

What about changing device_hotplug_lock and acpi_scan_lock to rwsem? like the
attached one(With a preliminary test, it also can make the splat go away).:)

Regards,
Gu

> 
[...]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 



--------------070907000804050000010406
Content-Type: text/plain;
 name="0001-acpi-fix-removal-lock-dep.patch"
Content-Disposition: attachment;
 filename="0001-acpi-fix-removal-lock-dep.patch"
Content-Transfer-Encoding: quoted-printable

>From f1682ceaef4105f75f4d6a0bb8e77c8a5dde365b Mon Sep 17 00:00:00 2001=0AFr=
om: Gu Zheng <guz.fnst@cn.fujitsu.com>=0ADate: Tue, 27 Aug 2013 17:59:55 +0=
900=0ASubject: [PATCH] acpi: fix removal lock dep=0A=0A=0ASigned-off-by: Gu=
 Zheng <guz.fnst@cn.fujitsu.com>=0A---=0A drivers/acpi/scan.c    |   43 +++=
+++++++++++++++++++---------------------=0A drivers/acpi/sysfs.c   |    7 +=
++++--=0A drivers/base/core.c    |   45 +++++++++++++++++++++++++++++++++++=
+---------=0A drivers/base/memory.c  |    5 +++--=0A include/linux/device.h=
 |    8 ++++++--=0A 5 files changed, 72 insertions(+), 36 deletions(-)=0A=
=0Adiff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c=0Aindex 8a46c92..=
bb41760 100644=0A--- a/drivers/acpi/scan.c=0A+++ b/drivers/acpi/scan.c=0A@@=
 -36,7 +36,7 @@ bool acpi=5Fforce=5Fhot=5Fremove;=0A static const char *dum=
my=5Fhid =3D "device";=0A =0A static LIST=5FHEAD(acpi=5Fbus=5Fid=5Flist);=
=0A-static DEFINE=5FMUTEX(acpi=5Fscan=5Flock);=0A+static DECLARE=5FRWSEM(ac=
pi=5Fscan=5Frwsem);=0A static LIST=5FHEAD(acpi=5Fscan=5Fhandlers=5Flist);=
=0A DEFINE=5FMUTEX(acpi=5Fdevice=5Flock);=0A LIST=5FHEAD(acpi=5Fwakeup=5Fde=
vice=5Flist);=0A@@ -49,13 +49,13 @@ struct acpi=5Fdevice=5Fbus=5Fid{=0A =0A=
 void acpi=5Fscan=5Flock=5Facquire(void)=0A {=0A-	mutex=5Flock(&acpi=5Fscan=
=5Flock);=0A+	down=5Fwrite(&acpi=5Fscan=5Frwsem);=0A }=0A EXPORT=5FSYMBOL=
=5FGPL(acpi=5Fscan=5Flock=5Facquire);=0A =0A void acpi=5Fscan=5Flock=5Frele=
ase(void)=0A {=0A-	mutex=5Funlock(&acpi=5Fscan=5Flock);=0A+	up=5Fwrite(&acp=
i=5Fscan=5Frwsem);=0A }=0A EXPORT=5FSYMBOL=5FGPL(acpi=5Fscan=5Flock=5Frelea=
se);=0A =0A@@ -207,7 +207,7 @@ static int acpi=5Fscan=5Fhot=5Fremove(struct=
 acpi=5Fdevice *device)=0A 		return -EINVAL;=0A 	}=0A =0A-	lock=5Fdevice=5F=
hotplug();=0A+	device=5Fhotplug=5Fbegin();=0A =0A 	/*=0A 	 * Carry out two =
passes here and ignore errors in the first pass,=0A@@ -240,7 +240,7 @@ stat=
ic int acpi=5Fscan=5Fhot=5Fremove(struct acpi=5Fdevice *device)=0A 					   =
 acpi=5Fbus=5Fonline=5Fcompanions, NULL,=0A 					    NULL, NULL);=0A =0A-		=
	unlock=5Fdevice=5Fhotplug();=0A+			device=5Fhotplug=5Fend();=0A =0A 			put=
=5Fdevice(&device->dev);=0A 			return -EBUSY;=0A@@ -252,7 +252,7 @@ static =
int acpi=5Fscan=5Fhot=5Fremove(struct acpi=5Fdevice *device)=0A =0A 	acpi=
=5Fbus=5Ftrim(device);=0A =0A-	unlock=5Fdevice=5Fhotplug();=0A+	device=5Fho=
tplug=5Fend();=0A =0A 	/* Device node has been unregistered. */=0A 	put=5Fd=
evice(&device->dev);=0A@@ -308,7 +308,7 @@ static void acpi=5Fbus=5Fdevice=
=5Feject(void *context)=0A 	struct acpi=5Fscan=5Fhandler *handler;=0A 	u32 =
ost=5Fcode =3D ACPI=5FOST=5FSC=5FNON=5FSPECIFIC=5FFAILURE;=0A =0A-	mutex=5F=
lock(&acpi=5Fscan=5Flock);=0A+	acpi=5Fscan=5Flock=5Facquire();=0A =0A 	acpi=
=5Fbus=5Fget=5Fdevice(handle, &device);=0A 	if (!device)=0A@@ -334,7 +334,7=
 @@ static void acpi=5Fbus=5Fdevice=5Feject(void *context)=0A 	}=0A =0A  ou=
t:=0A-	mutex=5Funlock(&acpi=5Fscan=5Flock);=0A+	acpi=5Fscan=5Flock=5Freleas=
e();=0A 	return;=0A =0A  err=5Fout:=0A@@ -349,8 +349,8 @@ static void acpi=
=5Fscan=5Fbus=5Fdevice=5Fcheck(acpi=5Fhandle handle, u32 ost=5Fsource)=0A 	=
u32 ost=5Fcode =3D ACPI=5FOST=5FSC=5FNON=5FSPECIFIC=5FFAILURE;=0A 	int erro=
r;=0A =0A-	mutex=5Flock(&acpi=5Fscan=5Flock);=0A-	lock=5Fdevice=5Fhotplug()=
;=0A+	acpi=5Fscan=5Flock=5Facquire();=0A+	device=5Fhotplug=5Fbegin();=0A =
=0A 	if (ost=5Fsource !=3D ACPI=5FNOTIFY=5FBUS=5FCHECK) {=0A 		acpi=5Fbus=
=5Fget=5Fdevice(handle, &device);=0A@@ -376,9 +376,9 @@ static void acpi=5F=
scan=5Fbus=5Fdevice=5Fcheck(acpi=5Fhandle handle, u32 ost=5Fsource)=0A 		ko=
bject=5Fuevent(&device->dev.kobj, KOBJ=5FONLINE);=0A =0A  out:=0A-	unlock=
=5Fdevice=5Fhotplug();=0A+	device=5Fhotplug=5Fend();=0A 	acpi=5Fevaluate=5F=
hotplug=5Fost(handle, ost=5Fsource, ost=5Fcode, NULL);=0A-	mutex=5Funlock(&=
acpi=5Fscan=5Flock);=0A+	acpi=5Fscan=5Flock=5Frelease();=0A }=0A =0A static=
 void acpi=5Fscan=5Fbus=5Fcheck(void *context)=0A@@ -469,15 +469,14 @@ void=
 acpi=5Fbus=5Fhot=5Fremove=5Fdevice(void *context)=0A 	acpi=5Fhandle handle=
 =3D device->handle;=0A 	int error;=0A =0A-	mutex=5Flock(&acpi=5Fscan=5Floc=
k);=0A+	acpi=5Fscan=5Flock=5Facquire();=0A =0A 	error =3D acpi=5Fscan=5Fhot=
=5Fremove(device);=0A 	if (error && handle)=0A 		acpi=5Fevaluate=5Fhotplug=
=5Fost(handle, ej=5Fevent->event,=0A 					  ACPI=5FOST=5FSC=5FNON=5FSPECIFI=
C=5FFAILURE,=0A 					  NULL);=0A-=0A-	mutex=5Funlock(&acpi=5Fscan=5Flock);=
=0A+	acpi=5Fscan=5Flock=5Frelease();=0A 	kfree(context);=0A }=0A EXPORT=5FS=
YMBOL(acpi=5Fbus=5Fhot=5Fremove=5Fdevice);=0A@@ -530,7 +529,8 @@ acpi=5Feje=
ct=5Fstore(struct device *d, struct device=5Fattribute *attr,=0A 	if (ACPI=
=5FFAILURE(status) || !acpi=5Fdevice->flags.ejectable)=0A 		return -ENODEV;=
=0A =0A-	mutex=5Flock(&acpi=5Fscan=5Flock);=0A+	if (!down=5Fwrite=5Ftrylock=
(&acpi=5Fscan=5Frwsem))=0A+		return -EBUSY;=0A =0A 	if (acpi=5Fdevice->flag=
s.eject=5Fpending) {=0A 		/* ACPI eject notification event. */=0A@@ -560,7 =
+560,7 @@ acpi=5Feject=5Fstore(struct device *d, struct device=5Fattribute =
*attr,=0A 	ret =3D count;=0A =0A  out:=0A-	mutex=5Funlock(&acpi=5Fscan=5Flo=
ck);=0A+	up=5Fwrite(&acpi=5Fscan=5Frwsem);=0A 	return ret;=0A =0A  err=5Fou=
t:=0A@@ -1858,11 +1858,12 @@ void acpi=5Fscan=5Fhotplug=5Fenabled(struct ac=
pi=5Fhotplug=5Fprofile *hotplug, bool val)=0A 	if (!!hotplug->enabled =3D=
=3D !!val)=0A 		return;=0A =0A-	mutex=5Flock(&acpi=5Fscan=5Flock);=0A+	acpi=
=5Fscan=5Flock=5Facquire();=0A =0A 	hotplug->enabled =3D val;=0A =0A-	mutex=
=5Funlock(&acpi=5Fscan=5Flock);=0A+	acpi=5Fscan=5Flock=5Frelease();=0A+=0A =
}=0A =0A static void acpi=5Fscan=5Finit=5Fhotplug(acpi=5Fhandle handle, int=
 type)=0A@@ -2141,7 +2142,7 @@ int =5F=5Finit acpi=5Fscan=5Finit(void)=0A 	=
acpi=5Fmemory=5Fhotplug=5Finit();=0A 	acpi=5Fdock=5Finit();=0A =0A-	mutex=
=5Flock(&acpi=5Fscan=5Flock);=0A+	acpi=5Fscan=5Flock=5Facquire();=0A 	/*=0A=
 	 * Enumerate devices in the ACPI namespace.=0A 	 */=0A@@ -2164,6 +2165,6 =
@@ int =5F=5Finit acpi=5Fscan=5Finit(void)=0A 	acpi=5Fpci=5Froot=5Fhp=5Fini=
t();=0A =0A  out:=0A-	mutex=5Funlock(&acpi=5Fscan=5Flock);=0A+	acpi=5Fscan=
=5Flock=5Frelease();=0A 	return result;=0A }=0Adiff --git a/drivers/acpi/sy=
sfs.c b/drivers/acpi/sysfs.c=0Aindex 05306a5..6d8b54f 100644=0A--- a/driver=
s/acpi/sysfs.c=0A+++ b/drivers/acpi/sysfs.c=0A@@ -796,9 +796,12 @@ static s=
size=5Ft force=5Fremove=5Fstore(struct kobject *kobj,=0A 	if (ret < 0)=0A 	=
	return ret;=0A =0A-	lock=5Fdevice=5Fhotplug();=0A+	if (!write=5Flock=5Fdev=
ice=5Fhotplug())=0A+		return -EBUSY;=0A+=0A 	acpi=5Fforce=5Fhot=5Fremove =
=3D val;=0A-	unlock=5Fdevice=5Fhotplug();=0A+=0A+	write=5Funlock=5Fdevice=
=5Fhotplug();=0A 	return size;=0A }=0A =0Adiff --git a/drivers/base/core.c =
b/drivers/base/core.c=0Aindex 8856d74..83c0f46 100644=0A--- a/drivers/base/=
core.c=0A+++ b/drivers/base/core.c=0A@@ -408,9 +408,13 @@ static ssize=5Ft =
show=5Fonline(struct device *dev, struct device=5Fattribute *attr,=0A {=0A =
	bool val;=0A =0A-	lock=5Fdevice=5Fhotplug();=0A+	if (!read=5Flock=5Fdevice=
=5Fhotplug()) {=0A+		msleep(10);=0A+		return restart=5Fsyscall();=0A+	}=0A+=
=0A 	val =3D !dev->offline;=0A-	unlock=5Fdevice=5Fhotplug();=0A+	read=5Funl=
ock=5Fdevice=5Fhotplug();=0A 	return sprintf(buf, "%u\n", val);=0A }=0A =0A=
@@ -424,9 +428,12 @@ static ssize=5Ft store=5Fonline(struct device *dev, st=
ruct device=5Fattribute *attr,=0A 	if (ret < 0)=0A 		return ret;=0A =0A-	lo=
ck=5Fdevice=5Fhotplug();=0A+	if (!write=5Flock=5Fdevice=5Fhotplug()) {=0A+	=
	msleep(10);=0A+		return restart=5Fsyscall();=0A+	}=0A 	ret =3D val ? devic=
e=5Fonline(dev) : device=5Foffline(dev);=0A-	unlock=5Fdevice=5Fhotplug();=
=0A+	write=5Funlock=5Fdevice=5Fhotplug();=0A 	return ret < 0 ? ret : count;=
=0A }=0A =0A@@ -1479,16 +1486,36 @@ EXPORT=5FSYMBOL=5FGPL(put=5Fdevice);=0A=
 EXPORT=5FSYMBOL=5FGPL(device=5Fcreate=5Ffile);=0A EXPORT=5FSYMBOL=5FGPL(de=
vice=5Fremove=5Ffile);=0A =0A-static DEFINE=5FMUTEX(device=5Fhotplug=5Flock=
);=0A+static DECLARE=5FRWSEM(device=5Fhotplug=5Frwsem);=0A+=0A+bool =5F=5Fm=
ust=5Fcheck read=5Flock=5Fdevice=5Fhotplug(void)=0A+{=0A+	return down=5Frea=
d=5Ftrylock(&device=5Fhotplug=5Frwsem);=0A+}=0A+=0A+void read=5Funlock=5Fde=
vice=5Fhotplug(void)=0A+{=0A+	up=5Fread(&device=5Fhotplug=5Frwsem);=0A+}=0A=
+=0A+bool =5F=5Fmust=5Fcheck write=5Flock=5Fdevice=5Fhotplug(void)=0A+{=0A+=
	return down=5Fwrite=5Ftrylock(&device=5Fhotplug=5Frwsem);=0A+}=0A+=0A+void=
 write=5Funlock=5Fdevice=5Fhotplug(void)=0A+{=0A+	up=5Fwrite(&device=5Fhotp=
lug=5Frwsem);=0A+}=0A =0A-void lock=5Fdevice=5Fhotplug(void)=0A+void device=
=5Fhotplug=5Fbegin(void)=0A {=0A-	mutex=5Flock(&device=5Fhotplug=5Flock);=
=0A+	down=5Fwrite(&device=5Fhotplug=5Frwsem);=0A }=0A =0A-void unlock=5Fdev=
ice=5Fhotplug(void)=0A+void device=5Fhotplug=5Fend(void)=0A {=0A-	mutex=5Fu=
nlock(&device=5Fhotplug=5Flock);=0A+	up=5Fwrite(&device=5Fhotplug=5Frwsem);=
=0A }=0A =0A static int device=5Fcheck=5Foffline(struct device *dev, void *=
not=5Fused)=0Adiff --git a/drivers/base/memory.c b/drivers/base/memory.c=0A=
index 2b7813e..71991b9 100644=0A--- a/drivers/base/memory.c=0A+++ b/drivers=
/base/memory.c=0A@@ -351,7 +351,8 @@ store=5Fmem=5Fstate(struct device *dev=
,=0A =0A 	mem =3D container=5Fof(dev, struct memory=5Fblock, dev);=0A =0A-	=
lock=5Fdevice=5Fhotplug();=0A+	if (!write=5Flock=5Fdevice=5Fhotplug())=0A+	=
	return -EBUSY;=0A =0A 	if (!strncmp(buf, "online=5Fkernel", min=5Ft(int, c=
ount, 13))) {=0A 		offline =3D false;=0A@@ -373,7 +374,7 @@ store=5Fmem=5Fs=
tate(struct device *dev,=0A 	if (!ret)=0A 		dev->offline =3D offline;=0A =
=0A-	unlock=5Fdevice=5Fhotplug();=0A+	write=5Funlock=5Fdevice=5Fhotplug();=
=0A =0A 	if (ret)=0A 		return ret;=0Adiff --git a/include/linux/device.h b/=
include/linux/device.h=0Aindex 22b546a..08581f4 100644=0A--- a/include/linu=
x/device.h=0A+++ b/include/linux/device.h=0A@@ -893,8 +893,12 @@ static inl=
ine bool device=5Fsupports=5Foffline(struct device *dev)=0A 	return dev->bu=
s && dev->bus->offline && dev->bus->online;=0A }=0A =0A-extern void lock=5F=
device=5Fhotplug(void);=0A-extern void unlock=5Fdevice=5Fhotplug(void);=0A+=
extern bool read=5Flock=5Fdevice=5Fhotplug(void);=0A+extern void read=5Funl=
ock=5Fdevice=5Fhotplug(void);=0A+extern bool write=5Flock=5Fdevice=5Fhotplu=
g(void);=0A+extern void write=5Funlock=5Fdevice=5Fhotplug(void);=0A+extern =
void device=5Fhotplug=5Fbegin(void);=0A+extern void device=5Fhotplug=5Fend(=
void);=0A extern int device=5Foffline(struct device *dev);=0A extern int de=
vice=5Fonline(struct device *dev);=0A /*=0A-- =0A1.7.1=0A=0A=
=

--------------070907000804050000010406--
