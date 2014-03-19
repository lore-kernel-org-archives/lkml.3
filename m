Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbaCSXOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:14:15 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:42995 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585AbaCSXNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140319152855.GB31293@kroah.com>
References: <2899750.XG86R9S8KF@daeseok-laptop.cloud.net>
	<20140319152855.GB31293@kroah.com>
Date: Thu, 20 Mar 2014 08:13:50 +0900
Message-ID: <CAHb8M2DS+5f478droW7=8kY2t-qo7xAED9gM9U5qaatokdqr-Q@mail.gmail.com>
Subject: Re: [PATCH] staging: unisys: replace kzalloc/kfree with UISMALLOC/UISFREE
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel <devel@driverdev.osuosl.org>,
        sparmaintainer <sparmaintainer@unisys.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "benjamin.romer" <benjamin.romer@unisys.com>,
        "david.kershner" <david.kershner@unisys.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. I will remove __GFP_NORETRY for kmalloc/kzalloc and sent this again.

Thanks.
Daeseok Youn

2014-03-20 0:28 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Wed, Mar 19, 2014 at 04:58:52PM +0900, Daeseok Youn wrote:
>>
>> It doesn't need to trace status of buffer when buffers are
>> allocated/deallocated. So stuff of tracing memory status
>> are removed. And also UISMALLOC/UISFREE macro are removed
>> completetly. just use kzalloc/kfree.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/unisys/include/uisutils.h |    6 --
>>  drivers/staging/unisys/uislib/uislib.c    |  109 +++-------------------------
>>  drivers/staging/unisys/uislib/uisutils.c  |    5 +-
>>  3 files changed, 14 insertions(+), 106 deletions(-)
>>
>> diff --git a/drivers/staging/unisys/include/uisutils.h b/drivers/staging/unisys/include/uisutils.h
>> index 81b5d9b..1c6d872 100644
>> --- a/drivers/staging/unisys/include/uisutils.h
>> +++ b/drivers/staging/unisys/include/uisutils.h
>> @@ -340,12 +340,6 @@ static inline unsigned int Issue_VMCALL_FATAL_BYE_BYE(void)
>>  }
>>
>>  #define UIS_DAEMONIZE(nam)
>> -void *uislib_malloc(size_t siz, gfp_t gfp, U8 contiguous, char *fn, int ln);
>> -#define UISMALLOC(siz, gfp) uislib_malloc(siz, gfp, 1, __FILE__, __LINE__)
>> -#define UISVMALLOC(siz) uislib_malloc(siz, 0, 0, __FILE__, __LINE__)
>> -void uislib_free(void *p, size_t siz, U8 contiguous, char *fn, int ln);
>> -#define UISFREE(p, siz) uislib_free(p, siz, 1, __FILE__, __LINE__)
>> -#define UISVFREE(p, siz) uislib_free(p, siz, 0, __FILE__, __LINE__)
>>  void *uislib_cache_alloc(struct kmem_cache *cur_pool, char *fn, int ln);
>>  #define UISCACHEALLOC(cur_pool) uislib_cache_alloc(cur_pool, __FILE__, __LINE__)
>>  void uislib_cache_free(struct kmem_cache *cur_pool, void *p, char *fn, int ln);
>> diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
>> index 1737f3a..c0eaa15 100644
>> --- a/drivers/staging/unisys/uislib/uislib.c
>> +++ b/drivers/staging/unisys/uislib/uislib.c
>> @@ -316,7 +316,7 @@ create_bus(CONTROLVM_MESSAGE *msg, char *buf)
>>       size =
>>           sizeof(struct bus_info) +
>>           (deviceCount * sizeof(struct device_info *));
>> -     bus = UISMALLOC(size, GFP_ATOMIC);
>> +     bus = kzalloc(size, GFP_ATOMIC | __GFP_NORETRY);
>
> All of the crazy __GFP_NORETRY stuff can be removed, no driver should
> ever be using that.
>
>
>>       if (!bus) {
>>               LOGERR("CONTROLVM_BUS_CREATE Failed: kmalloc for bus failed.\n");
>>               POSTCODE_LINUX_3(BUS_CREATE_FAILURE_PC, busNo,
>> @@ -324,8 +324,6 @@ create_bus(CONTROLVM_MESSAGE *msg, char *buf)
>>               return CONTROLVM_RESP_ERROR_KMALLOC_FAILED;
>>       }
>>
>> -     memset(bus, 0, size);
>> -
>>       /* Currently by default, the bus Number is the GuestHandle.
>>        * Configure Bus message can override this.
>>        */
>> @@ -359,7 +357,7 @@ create_bus(CONTROLVM_MESSAGE *msg, char *buf)
>>                      bus->busNo);
>>               POSTCODE_LINUX_3(BUS_CREATE_FAILURE_PC, bus->busNo,
>>                                POSTCODE_SEVERITY_ERR);
>> -             UISFREE(bus, size);
>> +             kfree(bus);
>>               return CONTROLVM_RESP_ERROR_ALREADY_DONE;
>>       }
>>       if ((msg->cmd.createBus.channelAddr != 0)
>> @@ -380,14 +378,14 @@ create_bus(CONTROLVM_MESSAGE *msg, char *buf)
>>               cmd.add_vbus.busTypeGuid = msg->cmd.createBus.busDataTypeGuid;
>>               cmd.add_vbus.busInstGuid = msg->cmd.createBus.busInstGuid;
>>               if (!VirtControlChanFunc) {
>> -                     UISFREE(bus, size);
>> +                     kfree(bus);
>>                       LOGERR("CONTROLVM_BUS_CREATE Failed: virtpci callback not registered.");
>>                       POSTCODE_LINUX_3(BUS_CREATE_FAILURE_PC, bus->busNo,
>>                                        POSTCODE_SEVERITY_ERR);
>>                       return CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_FAILURE;
>>               }
>>               if (!VirtControlChanFunc(&cmd)) {
>> -                     UISFREE(bus, size);
>> +                     kfree(bus);
>>                       LOGERR("CONTROLVM_BUS_CREATE Failed: virtpci GUEST_ADD_VBUS returned error.");
>>                       POSTCODE_LINUX_3(BUS_CREATE_FAILURE_PC, bus->busNo,
>>                                        POSTCODE_SEVERITY_ERR);
>> @@ -485,9 +483,7 @@ destroy_bus(CONTROLVM_MESSAGE *msg, char *buf)
>>               bus->pBusChannel = NULL;
>>       }
>>
>> -     UISFREE(bus,
>> -             sizeof(struct bus_info) +
>> -             (bus->deviceCount * sizeof(struct device_info *)));
>> +     kfree(bus);
>>       return CONTROLVM_RESP_SUCCESS;
>>  }
>>
>> @@ -507,7 +503,7 @@ create_device(CONTROLVM_MESSAGE *msg, char *buf)
>>       POSTCODE_LINUX_4(DEVICE_CREATE_ENTRY_PC, devNo, busNo,
>>                        POSTCODE_SEVERITY_INFO);
>>
>> -     dev = UISMALLOC(sizeof(struct device_info), GFP_ATOMIC);
>> +     dev = kzalloc(sizeof(struct device_info), GFP_ATOMIC | __GFP_NORETRY);
>>       if (!dev) {
>>               LOGERR("CONTROLVM_DEVICE_CREATE Failed: kmalloc for dev failed.\n");
>>               POSTCODE_LINUX_4(DEVICE_CREATE_FAILURE_PC, devNo, busNo,
>> @@ -515,7 +511,6 @@ create_device(CONTROLVM_MESSAGE *msg, char *buf)
>>               return CONTROLVM_RESP_ERROR_KMALLOC_FAILED;
>>       }
>>
>> -     memset(dev, 0, sizeof(struct device_info));
>>       dev->channelTypeGuid = msg->cmd.createDevice.dataTypeGuid;
>>       dev->intr = msg->cmd.createDevice.intr;
>>       dev->channelAddr = msg->cmd.createDevice.channelAddr;
>> @@ -688,7 +683,7 @@ Away:
>>               dev->chanptr = NULL;
>>       }
>>
>> -     UISFREE(dev, sizeof(struct device_info));
>> +     kfree(dev);
>>       return result;
>>  }
>>
>> @@ -917,7 +912,7 @@ destroy_device(CONTROLVM_MESSAGE *msg, char *buf)
>>                               LOGINF("destroy_device, doing iounmap");
>>                               uislib_iounmap(dev->chanptr);
>>                       }
>> -                     UISFREE(dev, sizeof(struct device_info));
>> +                     kfree(dev);
>>                       bus->device[devNo] = NULL;
>>                       break;
>>               }
>> @@ -1343,69 +1338,7 @@ uislib_client_delete_vnic(U32 busNo)
>>       return 1;
>>  }
>>  EXPORT_SYMBOL_GPL(uislib_client_delete_vnic);
>> -
>> -                             /* end client_delete_vnic */
>> -
>> -static atomic_t Malloc_BytesInUse = ATOMIC_INIT(0);
>> -static atomic_t Malloc_BuffersInUse = ATOMIC_INIT(0);
>> -static atomic_t Malloc_FailuresAlloc = ATOMIC_INIT(0);
>> -static atomic_t Malloc_FailuresFree = ATOMIC_INIT(0);
>> -static atomic_t Malloc_TotalMallocs = ATOMIC_INIT(0);
>> -static atomic_t Malloc_TotalFrees = ATOMIC_INIT(0);
>> -
>> -void *
>> -uislib_malloc(size_t siz, gfp_t gfp, U8 contiguous, char *fn, int ln)
>> -{
>> -     void *p = NULL;
>> -
>> -     if (contiguous == 0) {
>> -             /* Allocate non-contiguous memory, such as in the
>> -             * add_vnic and add_vhba methods where we are rebooting
>> -             * the guest, for example.  Otherwise the contiguous
>> -             * memory allocation attempt results in an
>> -             * out-of-memory crash in the IOVM...
>> -             */
>> -             p = vmalloc(siz);
>> -     } else {
>> -             /* __GFP_NORETRY means "ok to fail", meaning kmalloc()
>> -             * can return NULL.  If you do NOT specify
>> -             * __GFP_NORETRY, Linux will go to extreme measures to
>> -             * get memory for you (like, invoke oom killer), which
>> -             * will probably cripple the system.
>> -             */
>> -             p = kmalloc(siz, gfp | __GFP_NORETRY);
>> -     }
>> -     if (p == NULL) {
>> -             LOGERR("uislib_malloc failed to alloc %d bytes @%s:%d",
>> -                    (int) siz, fn, ln);
>> -             atomic_inc(&Malloc_FailuresAlloc);
>> -             return NULL;
>> -     }
>> -     atomic_add((int) (siz), &Malloc_BytesInUse);
>> -     atomic_inc(&Malloc_BuffersInUse);
>> -     atomic_inc(&Malloc_TotalMallocs);       /* will eventually overflow */
>> -     return p;
>> -}
>> -EXPORT_SYMBOL_GPL(uislib_malloc);
>> -
>> -void
>> -uislib_free(void *p, size_t siz, U8 contiguous, char *fn, int ln)
>> -{
>> -     if (p == NULL) {
>> -             LOGERR("uislib_free NULL pointer @%s:%d", fn, ln);
>> -             atomic_inc(&Malloc_FailuresFree);
>> -             return;
>> -     }
>> -
>> -     if (contiguous == 0)
>> -             vfree(p);
>> -     else
>> -             kfree(p);
>> -     atomic_sub((int) (siz), &Malloc_BytesInUse);
>> -     atomic_dec(&Malloc_BuffersInUse);
>> -     atomic_inc(&Malloc_TotalFrees); /* will eventually overflow */
>> -}
>> -EXPORT_SYMBOL_GPL(uislib_free);
>> +/* end client_delete_vnic */
>>
>>  void *
>>  uislib_cache_alloc(struct kmem_cache *cur_pool, char *fn, int ln)
>> @@ -1605,24 +1538,6 @@ info_proc_read_helper(char **buff, int *buff_len)
>>       }
>>       read_unlock(&BusListLock);
>>
>> -     if (PLINE("Malloc bytes in use: %d\n",
>> -              atomic_read(&Malloc_BytesInUse)) < 0)
>> -             goto err_done;
>> -     if (PLINE("Malloc buffers in use: %d\n",
>> -               atomic_read(&Malloc_BuffersInUse)) < 0)
>> -             goto err_done;
>> -     if (PLINE("Malloc allocation failures: %d\n",
>> -               atomic_read(&Malloc_FailuresAlloc)) < 0)
>> -             goto err_done;
>> -     if (PLINE("Malloc free failures: %d\n",
>> -               atomic_read(&Malloc_FailuresFree)) < 0)
>> -             goto err_done;
>> -     if (PLINE("Malloc total mallocs: %u (may overflow)\n",
>> -               (unsigned) atomic_read(&Malloc_TotalMallocs)) < 0)
>> -             goto err_done;
>> -     if (PLINE("Malloc total frees: %u (may overflow)\n",
>> -               (unsigned) atomic_read(&Malloc_TotalFrees)) < 0)
>> -             goto err_done;
>>       if (PLINE("UisUtils_Registered_Services: %d\n",
>>                 atomic_read(&UisUtils_Registered_Services)) < 0)
>>               goto err_done;
>> @@ -1655,7 +1570,7 @@ info_proc_read(struct file *file, char __user *buf, size_t len, loff_t *offset)
>>  /* *start = buf; */
>>       if (ProcReadBuffer == NULL) {
>>               DBGINF("ProcReadBuffer == NULL; allocating buffer.\n.");
>> -             ProcReadBuffer = UISVMALLOC(PROC_READ_BUFFER_SIZE);
>> +             ProcReadBuffer = vmalloc(PROC_READ_BUFFER_SIZE);
>>
>>               if (ProcReadBuffer == NULL) {
>>                       LOGERR("failed to allocate buffer to provide proc data.\n");
>> @@ -1691,7 +1606,7 @@ platformnumber_proc_read(struct file *file, char __user *buf,
>>       if (pos > 0 || !len)
>>               return 0;
>>
>> -     vbuf = kzalloc(len, GFP_KERNEL);
>> +     vbuf = kzalloc(len, GFP_KERNEL | __GFP_NORETRY);
>
> Why did you change this line?
>
> thanks,
>
> greg k-h
