Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaI3RHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:07:33 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:52832 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaI3RHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:07:31 -0400
MIME-Version: 1.0
Reply-To: rajatxjain@gmail.com
In-Reply-To: <CAAVjN7dqOAsF7iO4=02xaRBs8=+==84XW33Bu1sZXvrAVt8ZyQ@mail.gmail.com>
References: <542A36E9.9020205@gmail.com>
	<CAAVjN7dqOAsF7iO4=02xaRBs8=+==84XW33Bu1sZXvrAVt8ZyQ@mail.gmail.com>
Date: Tue, 30 Sep 2014 10:00:14 -0700
Message-ID: <CAA93t1ozo7OoxGquBcOpD1+SYJyFp6-Cnr5WQVoF-aQdCOSMRQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] Documentation: Add documentation for the PCI switch
 PEX8xxx I2C driver
From: Rajat Jain <rajatxjain@gmail.com>
To: Danielle Costantino <danielle.costantino@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        linux-doc <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Danielle,

Yes, I can add this support (for PEX89xx devices) to this driver
subsequently. I'd however first wait for review comments on the
current code (with the devices it currently supports).

Thanks & Best Regards,

Rajat


On Tue, Sep 30, 2014 at 2:46 AM, Danielle Costantino
<danielle.costantino@gmail.com> wrote:
> I have also been working on a driver (userspace) for the plx89xx devices, If
> any of this code is useful in the development of the plx driver, feel free
> to include it.
>
> #define PLX_CMD_LEN 4
> #define PLX_CMD_I2C_READ 0x04
> #define PLX_CMD_I2C_WRITE 0x03
> #define PLX_CMD2_MASK 0x0f
> #define PLX_PORT_SEL_B1(port) (port >> 1)
> #define PLX_PORT_SEL_B0(port) ((port & 1) << 7)
> #define PLX_CMD3_EN_ALL_BYTES 0x3c
> #define PLX_REG_MASK 0xffc
> #define PLX_REGISTER_ADDR(addr) ((uint16_t)((addr & PLX_REG_MASK) >> 2))
> #define PLX_REGISTER_ADDR_CMD3(addr) ((uint8_t)((PLX_REGISTER_ADDR(addr) >>
> 8) & 0x3))
> #define PLX_REGISTER_ADDR_CMD4(addr) ((uint8_t)(PLX_REGISTER_ADDR(addr) &
> 0xff))
>
> enum plx_station {
> plx_station_0 = 0x0,
> plx_station_1,
> plx_station_2,
> plx_station_3,
> plx_station_4,
> plx_station_5,
> plx_nt_port_vt,    // when bit 4 value is 0
> };
>
> enum plx_port {
> plx_port_0 = 0x0,
> plx_port_1,
> plx_port_2,
> plx_port_3,
> };
>
> static int pcie_i2c_read(SMBusdev *client, uint32_t *data,
> enum plx_station station, enum plx_port port, uint16_t addr) {
> int err = 0;
> uint8_t plx_read_i2c_data[PLX_CMD_LEN] = {
> [0] = PLX_CMD_I2C_READ,
> [1] = ((0x00) | (station << 1) | (PLX_PORT_SEL_B1(port))),
> [2] = ((PLX_REGISTER_ADDR_CMD3(addr)) | (PLX_CMD3_EN_ALL_BYTES) |
> (PLX_PORT_SEL_B0(port))),
> [3] = (PLX_REGISTER_ADDR_CMD4(addr)),
> };
>
> }
>
>
> On Mon, Sep 29, 2014 at 9:51 PM, Rajat Jain <rajatxjain@gmail.com> wrote:
>>
>>
>> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
>> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
>> Signed-off-by: Guenter Roeck <groeck@juniper.net>
>> ---
>>  Documentation/PCI/pex8xxx_i2c.txt |  134
>> +++++++++++++++++++++++++++++++++++++
>>  1 file changed, 134 insertions(+)
>>  create mode 100644 Documentation/PCI/pex8xxx_i2c.txt
>>
>> diff --git a/Documentation/PCI/pex8xxx_i2c.txt
>> b/Documentation/PCI/pex8xxx_i2c.txt
>> new file mode 100644
>> index 0000000..9195242
>> --- /dev/null
>> +++ b/Documentation/PCI/pex8xxx_i2c.txt
>> @@ -0,0 +1,134 @@
>>
>> +================================================================================
>> +                    The PEX8xxx I2C Interface driver
>> +
>> +                Rajat Jain <rajatjain@juniper.net> - Sep 2014
>>
>> +================================================================================
>> +
>> +0. Why have an I2C interface to a PCIe switch?
>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> +Other than the regular PCI express interface, most modern PCIe switches
>> (e.g.
>> +from IDT and PLX) have an I2C based secondary interface. This interface
>> allows
>> +access to all the registers of the switch. Some of these registers may
>> not even
>> +be accessible over the regular PCI interface. Also, there are certain
>> registers
>> +that can be written to, using only the I2C interface and may only be
>> read-only
>> +using the PCI interface.
>> +
>> +This I2C interface is often used in designs involving these switches, and
>> can
>> +be used for a variety of use cases where the switch needs to be
>> configured
>> +independent of the PCI subsystem (and likely before PCI enumeration).
>> Some
>> +examples:
>> +
>> +* Dividing a PCIe switch into multiple "virtual" switches. Using this
>> feature,
>> +  a switch could be connected to 2 root ports for instance, each managing
>> its
>> +  own PCI hierarchy, and the traffic from one virtual switch does not
>> leak into
>> +  another.
>> +
>> +* Managing Transparent / Non-transparent bridging, and changing them
>> on-the-fly.
>> +  There are ports that can be converted into "Non-transparent" bridge
>> ports.
>> +  Essentially this is used to create different domains (not visible to
>> +  software). In a dynamic distributed system, it may be desirable to
>> change a
>> +  transparent bridge to non-transparent or vice versa, for example, to
>> handle a
>> +  failover situation.
>> +
>> +* Buggy hardware / Bad EEPROM configuration. There may be cases where an
>> errata
>> +  involving register writes need to be applied before enumerating over
>> PCI.
>> +  Also these switches are typically attached to an EEPROM that is
>> supposed to
>> +  initialize the switch. If that EEPROM is not present, or contains bad
>> +  initialization data, this I2C interface can be used to fix that.
>> +
>> +* Changing switch configuration on the fly. In a multi-homed or complex
>> +  distributed systemsystem, there may be a need to change the switch
>> +  configuration (eg. change the upstream port, or the port or lane
>> +  configuration etc) to address run time scenarios (CPU plug out etc).
>> +
>> +1. What devices does this driver support?
>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> +PEX8xxx represents a family of PCI Express switches from the vendor PLX.
>> +(http://www.plxtech.com/products/expresslane/switches). Currently this
>> driver
>> +supports the following PLX switch devices:
>> +PEX8614
>> +PEX8618
>> +PEX8713
>> +
>> +2. What does this "PEX8xxx I2C Interface driver" do?
>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> +This driver is an I2C client driver that allows talking to the said
>> PEX8XXX
>> +PCIe switches over the I2C interface. In a nutshell, it currently
>> provides:
>> +
>> +* API calls to read / write the PEX8xxx switch device.
>> +* A sysfs interface, to read / write the PEX8xxx switch device.
>> +
>> +The API calls are self explanatory (all reads / writes are 32 bit wide,
>> but
>> +the argument "byte_mask" can be used to selectively mask out the bytes):
>> +
>> +int pex8xxx_read(struct i2c_client *client, u8 stn, u8 mode, u8
>> byte_mask,
>> +                 u8 port, u32 reg, u32 *val);
>> +int pex8xxx_write(struct i2c_client *client, u8 stn, u8 mode, u8
>> byte_mask,
>> +                  u8 port, u32 reg, u32 val)
>> +
>> +The arguments correspond to the arguments as described in the Chapter 7
>> +"I2C/SMBus Slave Interface Operation" of the all the switch datasheets.
>>
>> +http://www.plxtech.com/products/expresslane/pex8614#technicaldocumentation
>>
>> +http://www.plxtech.com/products/expresslane/pex8618#technicaldocumentation
>>
>> +http://www.plxtech.com/products/expresslane/pex8713#technicaldocumentation
>> +
>> +The sysfs interface is described in the next section.
>> +
>> +3. The PEX8xxx I2C driver sysfs Interface
>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> +The sysfs interface allows to read / write / dump the registers of any
>> given
>> +port of the pex8xxx switch. Note that all reads / writes are 32 bit wide.
>> For
>> +all pex8xxx devices, the following sysfs attributes are provided by this
>> driver
>> +in the directory /sys/bus/i2c/drivers/pex8xxx/<i2c-client-device>/
>> +
>> +* "port_num" (RW) - The port number whose registers are to be read /
>> written.
>> +* "reg_addr" (RW) - The register offset (within the port register space)
>> that
>> +                    is to be read / written.
>> +* "reg_value"(RW) - When read, it gives the value of the register at
>> offset
>> +                    "reg_addr" in the port "port_num" of the switch. When
>> +                    written, it writes the value to the same register.
>> +* "port_config_regs" (RO) - A binary dump of the 4KB register address
>> space of
>> +                    the port "port_num".
>> +
>> +In addition, some devices (currently PEX8713) support and require
>> additional
>> +parameters, and hence these will appear for PEX8713 only currently:
>> +
>> +* "port_mode" (RW) - Denotes the port mode to use to talk to the switch.
>> Valid
>> +                     values are: "transparent" / "nt-link" / "nt-virtual"
>> /
>> +                     "dma".
>> +* "port_stn" (RW) -  Port Station number.
>> +
>> +Note all the attributes preserve their value unless explicitly changed.
>> Thus if
>> +port_num is set to 5, then all subsequent reads / writes will be directed
>> to
>> +that port unless the port_num attribute is explicitly changed.
>> +
>> +4. Examples using sysfs interface
>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> +
>> +* Instantiate the device (refer
>> "Documentation/i2c/instantiating-devices").
>> +  Valid strings of device names for this driver are "pex8614", "pex8618"
>> and
>> +  "pex8713".
>> +  Example (pex8614 at I2C address 0x38 on I2C bus 55):
>> +  echo pex8614 0x38 > /sys/bus/i2c/devices/i2c-55/new_device
>> +
>> +* Verify if device was instantiated:
>> +  cd /sys/bus/i2c/drivers/pex8xxx/55-0038
>> +  cat name (should give pex8614)
>> +
>> +* Dump all registers of port number 4:
>> +  echo 4 > port_num
>> +  od -x port_config_regs
>> +
>> +* Get register values at offsets 0x230, 0x234, 0x238 of port number 1:
>> +  echo 1 > port_num
>> +  echo 0x230 > reg_addr
>> +  cat reg_value
>> +  echo 0x234 > reg_addr
>> +  cat reg_value
>> +  echo 0x238 > reg_addr
>> +  cat reg_value
>> +
>> +* Write value 0x101 at offset 0x530 of port number 5:
>> +  echo 5 > port_num
>> +  echo 0x530 > reg_addr
>> +  echo 0x101 > reg_value
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>
> --
> - Danielle Costantino
