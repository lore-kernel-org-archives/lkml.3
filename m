Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaLXJVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 04:21:18 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51914 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaLXJVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 04:21:14 -0500
Message-ID: <549A855C.3090806@gmail.com>
Date: Wed, 24 Dec 2014 14:50:28 +0530
From: Sanchayan Maity <maitysanchayan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Chen <Peter.Chen@freescale.com>
CC: "stefan@agner.ch" <stefan@agner.ch>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] usb: chipidea: add one errata for revision 2.40a
References: <cover.1418981438.git.maitysanchayan@gmail.com> <20141222011840.GB9242@shlinux2> <54981816.4010708@gmail.com> <20141223000940.GA11551@shlinux2> <549A7057.3030406@gmail.com> <BN3PR0301MB084931C32ABB2549E6A73CF581540@BN3PR0301MB0849.namprd03.prod.outlook.com>
In-Reply-To: <BN3PR0301MB084931C32ABB2549E6A73CF581540@BN3PR0301MB0849.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2014 02:30 PM, Peter Chen wrote:
>  
>>
>> On 12/23/2014 05:39 AM, Peter Chen wrote:
>>> On Mon, Dec 22, 2014 at 06:39:42PM +0530, Sanchayan Maity wrote:
>>>> On 12/22/2014 06:48 AM, Peter Chen wrote:
>>>>> On Fri, Dec 19, 2014 at 03:25:26PM +0530, Sanchayan Maity wrote:
>>>>>> The first two patches add identification register API's. These can
>>>>>> be used to get controller's revision.
>>>>>>
>>>>>> The third patch implements an errata for revision 2.40a. Not sure
>>>>>> which other SOCs implement this version of the Chipidea core but
>>>>>> this fixes the usb client issue observed on Vybrids. The patch was
>>>>>> tested on a Toradex Colibri VF61 module with the 3.18 kernel. iperf
>>>>>> tests ran for three hours plus, with these patches applied have
>>>>>> found the USB client connection to be now reliable.
>>>>>
>>>>> Would you help do a overnight test? It is passed, I will queue them,
>>>>> thanks.
>>>>
>>>> Yes definitely I can help with the testing. Are you looking for iperf
>>>> tests only or something else? iperf tests running for 12 or 24 hours
>>>> will do? I will need a bit of time to set things up here, as I am
>>>> away from work, but, ya I will do them.
>>>>
>>>
>>> iperf for g_ncm or g_ether and bonnie++ for g_mass_storage if you can
>>> run, thanks.
>>
>> The tests were run on a Toradex Colibri Vybrid VF61 module having 256MB
>> RAM with the 3.18 kernel.
>>
>> The iperf tests ran for around 19 hours before I stopped it. A snip of the iperf
>> tests is below. Used the Ethernet Gadget class for this.
>>
>> [  4] 70453.0-70453.5 sec  6.89 MBytes   116 Mbits/sec
>> [  4] 70453.5-70454.0 sec  6.83 MBytes   115 Mbits/sec
>> [  4] 70454.0-70454.5 sec  6.84 MBytes   115 Mbits/sec
>> [  4] 70454.5-70455.0 sec  6.89 MBytes   116 Mbits/sec
>> [  4] 70455.0-70455.5 sec  6.90 MBytes   116 Mbits/sec
>> [  4] 70455.5-70456.0 sec  6.90 MBytes   116 Mbits/sec
>> [  4] 70456.0-70456.5 sec  6.82 MBytes   114 Mbits/sec
>> [  4] 70456.5-70457.0 sec  6.80 MBytes   114 Mbits/sec
>> [  4] 70457.0-70457.5 sec  6.89 MBytes   116 Mbits/sec
>> [  4] 70457.5-70458.0 sec  6.85 MBytes   115 Mbits/sec
>> [  4] 70458.0-70458.5 sec  6.82 MBytes   114 Mbits/sec
>> [  4] 70458.5-70459.0 sec  6.82 MBytes   114 Mbits/sec
>> [  4]  0.0-70459.2 sec   946 GBytes   115 Mbits/sec
>>
>> Ran bonnie++ on gadget mass storage. CPU usage around the time of running
>> this test was mostly around the 90% mark with the minimum at 60% plus.
>> The storage directory was formatted with ext4. bonnie++ version used is
>> 1.97 and was installed from the Arch repositories with pacman.
>>
>> The size of the file being specified for "lun" storage is 512MB. I have specified
>> 128MB RAM in the below run with the size of file for IO performance as 256MB.
>> Without this bonnie++ was giving me an error around the "Writing intelligently"
>> point. I assume this has to do with the file size bonnie++ uses for testing.
>>
> 
> What's your backfile for mass storage, mmc?

The backfile for this mass storage is a "file.img" in the /home/root directory created
with the dd command as below
dd if=/dev/zero of=file.img bs=1024 count=0 seek=$[1024*512]

The script I use for activating mass storage is as below:

/bin/mount none /mnt -t configfs
/bin/mkdir /mnt/usb_gadget/g1
cd /mnt/usb_gadget/g1
/bin/mkdir configs/c.1
/bin/mkdir functions/mass_storage.0
echo /home/root/file.img > functions/mass_storage.0/lun.0/file
/bin/mkdir strings/0x409
/bin/mkdir configs/c.1/strings/0x409
echo 0x006a > idProduct
echo 0x15a2 > idVendor
echo Freescale123 > strings/0x409/serialnumber
echo Freescale > strings/0x409/manufacturer
echo "Mass Storage Gadget" > strings/0x409/product
echo "Conf 1" > configs/c.1/strings/0x409/configuration
echo 200 > configs/c.1/MaxPower
ln -s functions/mass_storage.0 configs/c.1
echo ci_hdrc.0 > UDC

> You mean without this errata, running bonnie++ will meet error?

No, I didn't mean that. I meant if I do something like

sudo /usr/bin/bonnie++ -m Vybrid -r 256 -d /var/run/media/sanchayan/Vybrid/ -x 5 -u root -n 0

then this gives me an error. Not aware of the bonnie++ internals, but, I guess
this would be because bonnie++ uses some higher multiple of the block size to
write and the storage is much lesser than that. The exact output for this case
is as below

[sanchayan@Sanchayan-Arch ~]$ sudo /usr/bin/bonnie++ -m Vybrid -r 256 -d /var/run/media/sanchayan/Vybrid/ -x 5 -u root -n 0
[sudo] password for sanchayan: 
Using uid:0, gid:0.
format_version,bonnie_version,name,concurrency,seed,file_size,io_chunk_size,putc,putc_cpu,put_block,put_block_cpu,rewrite,rewrite_cpu,getc,getc_cpu,get_block,get_block_cpu,seeks,seeks_cpu,num_files,max_size,min_size,num_dirs,file_chunk_size,seq_create,seq_create_cpu,seq_stat,seq_stat_cpu,seq_del,seq_del_cpu,ran_create,ran_create_cpu,ran_stat,ran_stat_cpu,ran_del,ran_del_cpu,putc_latency,put_block_latency,rewrite_latency,getc_latency,get_block_latency,seeks_latency,seq_create_latency,seq_stat_latency,seq_del_latency,ran_create_latency,ran_stat_latency,ran_del_latency
Writing a byte at a time...done
Writing intelligently...Can't write block.: No such file or directory
Can't write block 61508.

> 
>> [sanchayan@Sanchayan-Arch ~]$ sudo /usr/bin/bonnie++ -m Vybrid -r 128 -d
>> /var/run/media/sanchayan/Vybrid/ -x 5 -u root -n 0 -s 256 Using uid:0, gid:0.
>> format_version,bonnie_version,name,concurrency,seed,file_size,io_chunk_si
>> ze,putc,putc_cpu,put_block,put_block_cpu,rewrite,rewrite_cpu,getc,getc_cp
>> u,get_block,get_block_cpu,seeks,seeks_cpu,num_files,max_size,min_size,nu
>> m_dirs,file_chunk_size,seq_create,seq_create_cpu,seq_stat,seq_stat_cpu,se
>> q_del,seq_del_cpu,ran_create,ran_create_cpu,ran_stat,ran_stat_cpu,ran_del
>> ,ran_del_cpu,putc_latency,put_block_latency,rewrite_latency,getc_latency,ge
>> t_block_latency,seeks_latency,seq_create_latency,seq_stat_latency,seq_del_
>> latency,ran_create_latency,ran_stat_latency,ran_del_latency
>> Writing a byte at a time...done
>> Writing intelligently...done
>> Rewriting...done
>> Reading a byte at a time...done
>> Reading intelligently...done
>> start 'em...done...done...done...done...done...
>> 1.97,1.97,Vybrid,1,1419409300,256M,,659,87,8341,1,9401,0,4222,98,+++++,+++,
>> 3539,19,,,,,,,,,,,,,,,,,,23042us,66us,59us,4482us,79us,475us,,,,,,
>> Writing a byte at a time...done
>> Writing intelligently...done
>> Rewriting...done
>> Reading a byte at a time...done
>> Reading intelligently...done
>> start 'em...done...done...done...done...done...
>> 1.97,1.97,Vybrid,1,1419409300,256M,,661,90,7689,1,9071,0,4011,99,+++++,+++,
>> 3426,20,,,,,,,,,,,,,,,,,,15406us,64us,62us,4667us,23us,10030us,,,,,,
>> Writing a byte at a time...done
>> Writing intelligently...done
>> Rewriting...done
>> Reading a byte at a time...done
>> Reading intelligently...done
>> start 'em...done...done...done...done...done...
>> 1.97,1.97,Vybrid,1,1419409300,256M,,673,89,8117,1,9451,0,3879,98,+++++,+++,
>> 3355,22,,,,,,,,,,,,,,,,,,14210us,45us,69us,5069us,21us,10052us,,,,,,
>> Writing a byte at a time...done
>> Writing intelligently...done
>> Rewriting...done
>> Reading a byte at a time...done
>> Reading intelligently...done
>> start 'em...done...done...done...done...done...
>> 1.97,1.97,Vybrid,1,1419409300,256M,,668,89,7801,1,9343,0,4099,98,+++++,+++,
>> 3336,16,,,,,,,,,,,,,,,,,,17019us,44us,75us,4920us,20us,10234us,,,,,,
>> Writing a byte at a time...done
>> Writing intelligently...done
>> Rewriting...done
>> Reading a byte at a time...done
>> Reading intelligently...done
>> start 'em...done...done...done...done...done...
>> 1.97,1.97,Vybrid,1,1419409300,256M,,676,89,7953,1,9494,0,3878,98,+++++,+++,
>> 3396,22,,,,,,,,,,,,,,,,,,14080us,56us,42us,5177us,23us,12224us,,,,,,
>>
>> Let me know if this is OK.
>  
> Thanks for making and testing the patch, it is really a good job.
> I will queue this patch in my chipidea tree.
> 

Thanks :). Happy to help.

-Sanchayan.

> Peter  
> 
